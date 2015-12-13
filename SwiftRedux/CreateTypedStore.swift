//
//  CreateTypedStore.swift
//  SwiftRedux
//
//  Created by Karl Bowden on 13/12/2015.
//  Copyright © 2015 Kare Media. All rights reserved.
//

/**
 Helper chain function that takes a StoreCreator and creates a TypedStore
 While this could have been a regular storeEnhancer, the current compose function expects the return type to be the same as the parameter type. So as it is
 now it doesn't work as seen on ReduxJs and need to be put first in the chain.

 - parameter storeEnhancers: storeEnhancers description

 - returns: return value description
 */
public func createTypedStore<T where T:State>(storeEnhancers: [StoreEnhancer] = []) -> (StoreCreator) -> (Reducer, State?) -> TypedStore<T>{

    return  { (next:StoreCreator) -> (Reducer, State?) -> TypedStore<T> in
        return { (reducer: Reducer, initialState: State?) -> TypedStore<T> in

            /// Will apply all storeEnhancers before applying the store creator
            let storeCreator = compose(storeEnhancers)(next)

            /// Will create a store with the compounded storeCreator
            let store = storeCreator(reducer: reducer, initialState: initialState)

            return convertStoreToTypedStore(store)
        }

    }
}

/**
 Helper function that converts a store complying to the Store protocol to a typed store.

 - parameter store: a store complying to the Store interface

 - returns: TypedStore<T>
 */
public func convertStoreToTypedStore<T where T:State>(store: Store) -> TypedStore<T>{
    return TypedStore(
        dispatch: store.dispatch,
        getState: { () -> T in
            return store.getState() as! T
        },
        subscribe: {(onNext: (T) -> Void) -> Disposable in
            return store.subscribe{(state: State) -> Void in
                onNext(state as! T)
            }
        }
    )
}
