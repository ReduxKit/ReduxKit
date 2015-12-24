//
//  MiddlewareApi.swift
//  ReduxKit
//
//  Created by Karl Bowden on 24/12/2015.
//  Copyright © 2015 Kare Media. All rights reserved.
//

// MARK: - Protocols

/**

 MiddlewareApiType protocol

*/
public protocol MiddlewareApiType {

    typealias State

    var dispatch: Dispatch { get }

    var getState: () -> State { get }

    init(dispatch: Dispatch, getState: () -> State)
}

// MARK: - Implementations

/**

 Store implementation

*/
public struct MiddlewareApi<State>: MiddlewareApiType {

    public let dispatch: Dispatch

    public let getState: () -> State

    public var state: State { return getState() }

    public init(dispatch: Dispatch, getState: () -> State) {
        self.dispatch = dispatch
        self.getState = getState
    }
}
