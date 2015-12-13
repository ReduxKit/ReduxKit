//
//  CreateStore.swift
//  SwiftRedux
//
//  Created by Aleksander Herforth Rendtslev on 09/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

/**
 Will create a store with the state specified as

 - parameter reducer:      reducer description
 - parameter action:       action description
 - parameter initialState: initialState description

 - returns: return value description
 */
public func createStore(reducer: Reducer, state: State?) -> Store {
    return createStreamStore(createSimpleStream, reducer: reducer, state: state)
}
