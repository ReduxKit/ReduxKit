//
//  Store.swift
//  ReduxKit
//
//  Created by Aleksander Herforth Rendtslev on 03/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

public typealias Dispatch = Action -> Action

// MARK: - Protocols

/**
 StoreType protocol

 Parameters:
 - dispatch: Dispatch = Action -> Action
 - subscribe: Subscriber = (() -> State) -> ReduxDisposable
 - getState: () -> State
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
 Store implementation

 Strongly typed alias examples:
 - `typealias AppState = Any`
 - `typealias Subscriber = AppState -> ()`
 - `typealias Store = Store<AppState>`

 Parameters:
 - dispatch: Dispatch = Action -> Action
 - subscribe: Subscriber = (() -> State) -> ReduxDisposable
 - getState: () -> State
 - state: State
 */
public struct Store<State>: StoreType {

    public let dispatch: Dispatch

    public let subscribe: (State -> ()) -> ReduxDisposable

    public let getState: () -> State

    public var state: State { return getState() }

    public init(
        dispatch: Dispatch,
        subscribe: (State -> ()) -> ReduxDisposable,
        getState: () -> State) {
            self.dispatch = dispatch
            self.subscribe = subscribe
            self.getState = getState
    }
}
