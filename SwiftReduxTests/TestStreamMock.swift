//
//  TestStreamMock.swift
//  SwiftRedux
//
//  Created by Karl Bowden on 14/12/2015.
//  Copyright © 2015 Kare Media. All rights reserved.
//

struct TestDisposable {}

func createTestStream<State>(state: State) -> StateStream<State, TestDisposable> {

    typealias Observer = State -> ()

    var latestState = state
    var observers = [Observer]()

    func next(state: State) {
        latestState = state
        observers.forEach() { $0(latestState) }
    }

    func observe(next: State -> ()) -> TestDisposable {
        observers.append(next)
        return TestDisposable()
    }

    return StateStream(next: next, observe: observe, latest: {latestState})
}

func createTestStore<State>(reducer: (State?, Action) -> State, state: State?) -> Store<State, TestDisposable> {
    return createStore(createTestStream, reducer: reducer, state: state)
}
