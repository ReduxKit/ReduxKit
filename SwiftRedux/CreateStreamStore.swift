//
//  CreateStreamStore.swift
//  SwiftRedux
//
//  Created by Karl Bowden on 13/12/2015.
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

 - parameter createStream: returns a StateStream from an initial state value
 - parameter reducer:      reducer description
 - parameter action:       action description
 - parameter initialState: initialState description

 - returns: return value description
 */
public func createStreamStore(createStream: State -> StateStream<State>, reducer: Reducer, state: State?) -> Store {

    let initialState: State = (state != nil) ? state! : reducer(state: state, action: DefaultAction())

    let stream = createStream(initialState)

    var isDispatching = false

    /**
     Will dispatch the given action to both reducers and middlewares

     - parameter action: the given action - that conforms to the protocol ActionType

     - returns: will return the action
     */
    func dispatch(action: Action) -> Action {
        do {
            try innerDispatch(action)
        } catch {
            print("Error dispatching. Are you dispatching from a reducer?")
        }

        return action
    }

    /**
     Will return the current state

     - returns: currentState
     */
    func getState() -> State {
        return stream.getState()
    }

    /**
     Will trigger onNext notifying al subscribers of the change

     - parameter action: the given Action

     - returns: the given action
     */
    func innerDispatch(action: Action) throws -> Action {

        /**
        *  the previous dispatch should be completed before the next one is initiated.
        */
        if (isDispatching) {
            throw StoreErrors.DispatchError
        }

        /**
        *  When the function is done running, reset the isDispatching variable
        */
        defer {
            isDispatching = false
        }

        isDispatching = true
        stream.publish(reducer(state: getState(), action: action))

        return action
    }

    /**
     Will subscribe to the stateSubjects onNext function

     - parameter onNext: Subscribe function

     - returns: will return the stateSubjects onNext function
     */
    func subscribe(onNext: State -> Void) -> Disposable {
        return stream.subscribe(onNext)
    }

    return StandardStore(dispatch: dispatch, getState: getState, subscribe: subscribe)
}
