//
//  SimpleStreamMock.swift
//  SwiftRedux
//
//  Created by Karl Bowden on 14/12/2015.
//  Copyright © 2015 Kare Media. All rights reserved.
//

func createSimpleStream<T>(state: T) -> StateStream<T> {
    let producer = EventProducer(state)

    func publish(state: T) {
        producer.next(state)
    }

    func subscribe(next: T -> ()) -> Disposable {
        return producer.observe(next)
    }

    func getState() -> T {
        return producer.value
    }

    return StateStream(publish: publish, subscribe: subscribe, getState: getState)
}

/**
 Will create a store with the state specified as

 - parameter reducer:      reducer description
 - parameter action:       action description
 - parameter initialState: initialState description

 - returns: return value description
 */
public func createStore(reducer: Reducer, state: State?) -> Store {
    return createStreamStore(createSimpleStream, reducer: reducer, state: state)
}
