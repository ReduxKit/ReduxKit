//
//  ApplyMiddleware.swift
//  ReduxKit
//
//  Created by Aleksander Herforth Rendtslev on 09/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

public typealias DispatchTransformer = Dispatch -> Dispatch

/**
 applyMiddlware creates a StoreEnhancer from an array of Middleware

 **Strongly typed signature**

 ```swift
 typealias MiddlewareApi = MiddlewareApi<State>
 typealias Middleware = MiddlewareApi -> DispatchTransformer
 typealias StoreCreator = (reducer: Reducer, initialState: State?) -> Store<State>
 typealias StoreEnhancer = StoreCreator -> StoreCreator
 func applyMiddleware(middleware: [Middleware]) -> StoreEnhancer
 ```

 - parameter middleware: An array of Middleware that accept a MiddlewareApi and return a
                         DispatchTransformer

 Returns `StoreEnhancer<State>`
*/
public func applyMiddleware<State>(middleware: [MiddlewareApi<State> -> DispatchTransformer])
    -> (((State?, Action) -> State, State?) -> Store<State>)
    -> (((State?, Action) -> State, State?) -> Store<State>) {

    return { next in { reducer, initialState in

        var dispatch: Dispatch!

        let store = next(reducer, initialState)

        let middlewareApi = MiddlewareApi(
            dispatch: { dispatch($0) },
            getState: store.getState)

        let middlewareChain = middleware.map { $0(middlewareApi) }

        dispatch = compose(middlewareChain)(store.dispatch)

        return Store(
            dispatch: dispatch,
            subscribe: store.subscribe,
            getState: store.getState)
    }}
}
