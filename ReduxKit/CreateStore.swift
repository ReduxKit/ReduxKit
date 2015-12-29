//
//  CreateStore.swift
//  ReduxKit
//
//  Created by Karl Bowden on 13/12/2015.
//  Copyright © 2015 Kare Media. All rights reserved.
//

/**
 Creates a ReduxKit Store of a generic State type

 **Strongly typed signature**

 ```swift
 typealias Reducer = (State?, Action) -> State
 func createStore(reducer: Reducer, state: State?) -> Store
 ```

 - parameter reducer: (State?, Action) -> State
 - parameter state:   State

 - returns: Store<State>
 */
public func createStore<State>(reducer: (State?, Action) -> State, state: State?) -> Store<State> {

    typealias Subscriber = State -> ()

    var currentState = state ?? reducer(state, DefaultAction())
    var nextToken = 0
    var subscribers = [Int: Subscriber]()
    var isDispatching = false

    func dispatch(action: Action) -> Action {
        if isDispatching {
            // Use Obj-C exception since throwing of exceptions can be verified through tests
            NSException.raise("ReduxKit:IllegalDispatchFromReducer", format: "Reducers may not " +
                "dispatch actions.", arguments: getVaList(["nil"]))
        }
        isDispatching = true
        currentState = reducer(currentState, action)
        isDispatching = false

        for (_, subscriber) in subscribers {
            subscriber(currentState)
        }
        return action
    }

    func getToken() -> Int {
        let token = nextToken
        nextToken += 1
        return token
    }

    func subscribe(subscriber: State -> ()) -> ReduxDisposable {
        let token = getToken()
        subscribers[token] = subscriber
        return SimpleReduxDisposable(
            disposed: { subscribers[token] == nil },
            dispose: { subscribers.removeValueForKey(token) })
    }

    return Store(dispatch: dispatch, subscribe: subscribe, getState: { currentState })
}
