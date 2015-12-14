//
//  ApplyMiddlewares.swift
//  SwiftRedux
//
//  Created by Aleksander Herforth Rendtslev on 09/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

public typealias Middleware = (Dispatch) -> Dispatch

/**
 applyMiddleware. Will chain the specified middlewares so they are called before the reducers.

 - parameter middlewares: middlewares description

 - returns: return value description
 */

public func applyMiddleware<State, Disposable>(middleware: Middleware, store: Store<State, Disposable>) -> Store<State, Disposable> {
    return Store(dispatch: middleware(store.dispatch), observe: store.observe, latest: store.latest)
}

public func applyMiddlewares<State, Disposable>(middlewares: [Middleware], store: Store<State, Disposable>) -> Store<State, Disposable> {
    let dispatch = middlewares.reverse().reduce(store.dispatch) { $1($0) }
    return Store(dispatch: dispatch, observe: store.observe, latest: store.latest)
}
