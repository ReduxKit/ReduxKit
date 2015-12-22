//
//  ApplyMiddleware.swift
//  ReduxKit
//
//  Created by Aleksander Herforth Rendtslev on 09/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

public typealias DispatchTransformer = Dispatch -> Dispatch

typealias _MiddlewareApi = Store<_State>
typealias _Middleware = _MiddlewareApi -> DispatchTransformer
typealias _StoreCreator = (reducer: _Reducer, initialState: _State?) -> Store<_State>
typealias _StoreEnhancer = _StoreCreator -> _StoreCreator


/**
 Internal example:
    applyMiddleware([Middleware]) -> StoreEnhancer
 */
func _applyMiddleware(middlewares: [_Middleware]) -> _StoreEnhancer {
    return applyMiddleware(middlewares)
}

public func applyMiddleware<State>(middleware: [Store<State> -> DispatchTransformer])
    -> (((State?, Action) -> State, State?) -> Store<State>)
    -> (((State?, Action) -> State, State?) -> Store<State>) {

    return { next in
        return { reducer, initialState in

            let store = next(reducer, initialState)

            var dispatch: Dispatch = store.dispatch

            let middlewareApi = Store(
                dispatch: { dispatch($0) },
                subscribe: { _ in SimpleReduxDisposable(disposed: { false }, dispose: {}) },
                getState: store.getState)

            /// Create an array of DispatchTransformers
            let chain = middleware.map { $0(middlewareApi) }

            dispatch = compose(chain)(store.dispatch)

            return Store(dispatch: dispatch, subscribe: store.subscribe, getState: store.getState)
        }
    }
}
