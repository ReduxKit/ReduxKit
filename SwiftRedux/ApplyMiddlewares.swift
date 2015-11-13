//
//  ApplyMiddlewares.swift
//  SwiftRedux
//
//  Created by Aleksander Herforth Rendtslev on 09/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//


public typealias MiddlewareReturnFunction = (DispatchFunction) -> DispatchFunction

public func applyMiddlewares<T where T:StateType>(middlewares: [(MiddlewareApi<T>) -> MiddlewareReturnFunction]) -> (((T, ActionType)-> T, T)  -> Store<T>) -> ((T,ActionType)-> T, T) -> Store<T>{
    return {(next: ((T, ActionType)-> T, T) -> Store<T>) in
        return {(reducer: (T, ActionType)-> T, initialState: T) in
            let store = next(reducer, initialState)
            // Create Middleware api - a simplified version of a store
            let middlewareAPI = MiddlewareApi(getState: store.getState, dispatch: store.dispatch)
            
            /// Create an array of middlewareReturnFunctions
            let chain = middlewares.map{ middleware in
                middleware(middlewareAPI)
            }
            
            
            // Compounded dispatch function
            let dispatch = compose(chain)(store.dispatch)
            
            // Return a store with an enhanced dispatch function
            return Store(
                dispatch: dispatch,
                getState: store.getState,
                subscribe: store.subscribe)
        }
    
    }
}

public struct MiddlewareApi<T where T:StateType>{
    public let getState:() -> T
    public let dispatch: DispatchFunction
}