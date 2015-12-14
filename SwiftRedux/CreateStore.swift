//
//  CreateStore.swift
//  SwiftRedux
//
//  Created by Karl Bowden on 13/12/2015.
//  Copyright © 2015 Kare Media. All rights reserved.
//

public func createStore<State, Disposable>(streamFactory: State -> StateStream<State, Disposable>, reducer: (State?, Action) -> State, state: State?) -> Store<State, Disposable> {

    let initialState: State = (state != nil) ? state! : reducer(state, DefaultAction())
    let stream = streamFactory(initialState)

    func dispatch(action: Action) -> Action {
        stream.next(reducer(stream.latest(), action))
        return action
    }

    return Store(dispatch: dispatch, observe: stream.observe, latest: stream.latest)
}

public func createStoreFactory<State, Disposable>(streamFactory: State -> StateStream<State, Disposable>) -> (reducer: (State?, Action) -> State, state: State?) -> Store<State, Disposable> {
    return { (reducer: (State?, Action) -> State, state: State?) in
        return createStore(streamFactory, reducer: reducer, state: state)
    }
}
