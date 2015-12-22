//
//  Store.swift
//  ReduxKit
//
//  Created by Aleksander Herforth Rendtslev on 03/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

public typealias Dispatch = Action -> Action

// MARK: - Type map examples

typealias _State = Any
typealias _Subscriber = _State -> ()
typealias _Store = Store<_State>

// MARK: - Protocols

/**
 * StoreType protocol
 */
public protocol StoreType {

    typealias State

    var dispatch: Dispatch { get }

    var subscribe: (State -> ()) -> ReduxDisposable { get }

    var getState: () -> State { get }

    init(dispatch: Dispatch, subscribe: (State -> ()) -> ReduxDisposable, getState: () -> State)
}

// MARK: - Implementations

/**
 * Store implementation
 */
public struct Store<State>: StoreType {

    public let dispatch: Dispatch

    public let subscribe: (State -> ()) -> ReduxDisposable

    public let getState: () -> State

    public var state: State { return getState() }

    public init(dispatch: Dispatch, subscribe: (State -> ()) -> ReduxDisposable, getState: () -> State) {
        self.dispatch = dispatch
        self.subscribe = subscribe
        self.getState = getState
    }
}
