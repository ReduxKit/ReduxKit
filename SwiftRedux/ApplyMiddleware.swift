//
//  ApplyMiddleware.swift
//  SwiftRedux
//
//  Created by Aleksander Herforth Rendtslev on 09/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

public typealias DispatchTransformer = (Dispatch) -> Dispatch

public func applyMiddleware<State>(middlewares: [(Store<State>) -> DispatchTransformer]) -> (((State?, Action) -> State, State?) -> Store<State>) -> (((State?, Action) -> State, State?) -> Store<State>) {

    return { next in
        return { reducer, initialState in

            let store = next(reducer, initialState)

            var dispatch: Dispatch = store.dispatch

            let middlewareApi = Store(dispatch: { dispatch($0) }, subscribe: {_ in SimpleReduxDisposable(disposed: {false}, dispose: {})}, getState: store.getState)

            /// Create an array of DispatchTransformers
            let chain = middlewares.map { $0(middlewareApi) }

            dispatch = compose(chain)(store.dispatch)

            return Store(dispatch: dispatch, subscribe: store.subscribe, getState: store.getState)
        }
    }
}
