//
//  ApplyMiddlewares.swift
//  SwiftRedux
//
//  Created by Aleksander Herforth Rendtslev on 09/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//


public typealias MiddlewareReturnFunction = (Dispatch) -> Dispatch
public typealias Middleware = (api: MiddlewareApi) -> MiddlewareReturnFunction
public typealias StoreCreator = (reducer: Reducer, initialState: State?) -> Store
public typealias StoreEnhancer = (StoreCreator) -> StoreCreator



/**
 applyMiddleware. Will chain the specified middlewares so they are called before the reducers.
 
 - parameter middlewares: middlewares description
 
 - returns: return value description
 */
public func applyMiddlewares(middlewares: [Middleware]) -> StoreEnhancer{
    return { (next:StoreCreator) -> StoreCreator in
        return { (reducer: Reducer, initialState: State?) -> Store in
            let store = next(reducer: reducer, initialState: initialState)
            var dispatch = store.dispatch
            let middlewareApi = MiddlewareApi(
                getState: store.getState,
                dispatch: {(action: Action) -> Action in
                    return dispatch(action)
                })
            
            /// Create an array of middlewareReturnFunctions
            let chain = middlewares.map{ middleware in
                middleware(api: middlewareApi)
            }
            
            // Compounded dispatch function
            dispatch = compose(chain)(store.dispatch)
            
            return StandardStore(dispatch: dispatch, getState: store.getState, subscribe: store.subscribe)
        }
    }
}

/**
 *  MiddlewareApi - it its a simpler version of a Store
 */
public struct MiddlewareApi{
    public let getState:() -> State
    public let dispatch: Dispatch
}