//
//  StateStream.swift
//  SwiftRedux
//
//  Created by Karl Bowden on 14/12/2015.
//  Copyright © 2015 Kare Media. All rights reserved.
//

typealias _StateStream = StateStream<_State>

/**

 StateStream is the layer between reactive frameworks and SwiftRedux in order to
 produce States served by your perfered framework.

 */
public struct StateStream<State> {

    public let dispatch: State -> ()

    public let subscribe: (State -> ()) -> ReduxDisposable

    public let getState: () -> State

    public init(dispatch: State -> (), subscribe: (State -> ()) -> ReduxDisposable, getState: () -> State) {
        self.dispatch = dispatch
        self.subscribe = subscribe
        self.getState = getState
    }
}

/**

 createSimpleStream returns an array based StateStream subscription service.

 Although it can be used to push new State objects to an existing reactive
 framework, it would be better to create a specific StateStream using your
 reactive framework as the provider.

 createSimpleStream does not handle locks and is not thread safe. These choices
 are left to your own implementation and often handled best by existing
 frameworks.

*/
func createSimpleStream<State>(state: State) -> StateStream<State> {

    typealias Subscriber = State -> ()

    var currentState = state

    var nextToken = 0

    var subscribers = [Int: Subscriber]()

    func dispatch(state: State) {
        currentState = state
        for (_, subscriber) in subscribers {
            subscriber(state)
        }
    }

    func getToken() -> Int {
        let token = nextToken
        nextToken += 1
        return token
    }

    func subscribe(subscriber: State -> ()) -> ReduxDisposable {
        let token = getToken()
        subscribers[token] = subscriber
        return SimpleReduxDisposable(disposed: { subscribers[token] != nil }, dispose: { subscribers.removeValueForKey(token) })
    }

    return StateStream(dispatch: dispatch, subscribe: subscribe, getState: { currentState })
}
