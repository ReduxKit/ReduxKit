//
//  CreateStore.swift
//  SwiftRedux
//
//  Created by Karl Bowden on 13/12/2015.
//  Copyright © 2015 Kare Media. All rights reserved.
//


public func createStore<State>(reducer: (State?, Action) -> State, state: State?) -> Store<State> {

    return createStreamStore(reducer: reducer, state: state)
}

public func createStreamStore<State>(streamFactory: State -> StateStream<State> = createSimpleStream, reducer: (State?, Action) -> State, state: State?) -> Store<State> {

    let stream = streamFactory(state ?? reducer(state, DefaultAction()))

    func dispatch(action: Action) -> Action {
        stream.dispatch(reducer(stream.getState(), action))
        return action
    }

    return Store(dispatch: dispatch, subscribe: stream.subscribe, getState: stream.getState)
}

/// Used to build createStore functions with an alternative streamFactory
public func createStreamStore<State>(streamFactory: State -> StateStream<State>) -> (reducer: (State?, Action) -> State, state: State?) -> Store<State> {

    return { (reducer: (State?, Action) -> State, state: State?) in

        return createStreamStore(streamFactory, reducer: reducer, state: state)
    }
}
