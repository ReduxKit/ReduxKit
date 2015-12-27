//
//  ApplyMiddleware.swift
//  ReduxKit
//
//  Created by Aleksander Herforth Rendtslev on 09/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

public typealias DispatchTransformer = Dispatch -> Dispatch

typealias _MiddlewareApi = MiddlewareApi<_State>
typealias _Middleware = _MiddlewareApi -> DispatchTransformer
typealias _StoreCreator = (reducer: _Reducer, initialState: _State?) -> Store<_State>
typealias _StoreEnhancer = _StoreCreator -> _StoreCreator


/**
 Internal example:
    applyMiddleware([Middleware]) -> StoreEnhancer
 */
func _applyMiddleware(middleware: [_Middleware]) -> _StoreEnhancer {
    return applyMiddleware(middleware)
}

public func applyMiddleware<State>(middleware: [MiddlewareApi<State> -> DispatchTransformer])
    -> (((State?, Action) -> State, State?) -> Store<State>)
    -> (((State?, Action) -> State, State?) -> Store<State>) {

    return { next in
        return { reducer, initialState in

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
        }
    }
}
