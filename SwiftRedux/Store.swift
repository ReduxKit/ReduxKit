//
//  Store.swift
//  SwiftRedux
//
//  Created by Aleksander Herforth Rendtslev on 03/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

public typealias Dispatch = Action -> Action

/**
 * StoreType protocol
 */
public protocol StoreType {
    typealias State
    typealias Disposable

    var dispatch: Dispatch { get }
    var observe: ((State) -> ()) -> Disposable { get }
    var state: State { get }

    init(dispatch: Dispatch, observe: ((State) -> ()) -> Disposable, latest: () -> State)
}

/**
 * Store implementation
 */
public struct Store<State, Disposable>: StoreType {

    public let dispatch: Dispatch
    public let observe: (State -> ()) -> Disposable
    public var state: State { return latest() }
    let latest: () -> State

    public init(dispatch: Dispatch, observe: ((State) -> ()) -> Disposable, latest: () -> State) {
        self.dispatch = dispatch
        self.observe = observe
        self.latest = latest
    }
}
