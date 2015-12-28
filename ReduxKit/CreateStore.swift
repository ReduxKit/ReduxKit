//
//  CreateStore.swift
//  ReduxKit
//
//  Created by Karl Bowden on 13/12/2015.
//  Copyright © 2015 Kare Media. All rights reserved.
//

// MARK: - Type map examples

typealias _Reducer = (_State?, Action) -> _State
typealias _StreamFactory = _State -> _StateStream

// MARK: - Implementations

/**
 Internal createStore example
 */
func _createStore(reducer: _Reducer, state: _State?) -> _Store {
    return createStore(reducer, state: state)
}

public func createStore<State>(reducer: (State?, Action) -> State, state: State?)
    -> Store<State> {

    return createStreamStore(reducer: reducer, state: state)
}

/**
 Internal createStreamStore example
 */
func _createStreamStore(streamFactory: _StreamFactory, reducer: _Reducer, state: _State?)
    -> _Store {

    return createStreamStore(streamFactory, reducer: reducer, state: state)
}

public func createStreamStore<State>(
        streamFactory: State -> StateStream<State> = createSimpleStream,
        reducer: (State?, Action) -> State,
        state: State?)
    -> Store<State> {

    var isDispatching = false
    let stream = streamFactory(state ?? reducer(state, DefaultAction()))

    func dispatch(action: Action) -> Action {
        if isDispatching {
            // Use Obj-C exception since throwing of exceptions can be verified through tests
            NSException.raise("ReduxKit:IllegalDispatchFromReducer", format: "Reducers may not " +
                "dispatch actions.", arguments: getVaList(["nil"]))
        }

        isDispatching = true
        let newState = reducer(stream.getState(), action)
        isDispatching = false

        stream.dispatch(newState)
        return action
    }

    return Store(dispatch: dispatch, subscribe: stream.subscribe, getState: stream.getState)
}


/**
 Internal createStreamStore example
 */
func _createStreamStore(streamFactory: _StreamFactory) -> _StoreCreator {
    return _createStreamStore(streamFactory)
}

/// Used to build createStore functions with an alternative streamFactory
public func createStreamStore<State>(streamFactory: State -> StateStream<State>)
    -> (reducer: (State?, Action) -> State, state: State?)
    -> Store<State> {

    return { reducer, state in

        return createStreamStore(streamFactory, reducer: reducer, state: state)
    }
}
