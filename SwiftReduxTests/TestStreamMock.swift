//
//  TestStreamMock.swift
//  SwiftRedux
//
//  Created by Karl Bowden on 14/12/2015.
//  Copyright © 2015 Kare Media. All rights reserved.
//

struct MockDisposable: Disposable {
    var isDisposed: Bool = false
    func dispose() {}
}

func createTestStream<T>(state: T) -> StateStream<T> {
    var latestState = state
    typealias Observer = T -> ()
    var observers = [Observer]()

    func publish(state: T) {
        latestState = state
        observers.forEach() { observer in
            observer(latestState)
        }
    }

    func subscribe(next: T -> ()) -> Disposable {
        observers.append(next)
        return MockDisposable()
    }

    func getState() -> T {
        return latestState
    }

    return StateStream(publish: publish, subscribe: subscribe, getState: getState)
}

public func createTestStore(reducer: Reducer, state: State?) -> Store {
    return createStreamStore(createTestStream, reducer: reducer, state: state)
}
