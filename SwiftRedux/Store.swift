//
//  Store.swift
//  SwiftRedux
//
//  Created by Aleksander Herforth Rendtslev on 03/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

public typealias Dispatch = Action -> Action

/**
 *  Store protocol.
 */
public protocol Store{
    var dispatch: Dispatch {get}
    var getState: () -> State {get}
    var subscribe: (onNext: (State) -> Void) -> Disposable {get}
    init(dispatch: Dispatch, getState: ()-> State, subscribe: (onNext: (State) -> Void) -> Disposable)
}

/**
 *  Standard store
 */
public struct StandardStore : Store{
    public var dispatch: Dispatch
    public let getState: () -> State
    public let subscribe: (onNext: (State) -> Void) -> Disposable

    public init(dispatch: Dispatch, getState: ()-> State, subscribe: (onNext: (State) -> Void) -> Disposable){
        self.dispatch = dispatch
        self.getState = getState
        self.subscribe = subscribe
    }
}

/**
 *  TypedStore
 *  It removes the necessity of casting the state object everytime subscribe is called
 */
public struct TypedStore<T where T:State>{
    public let dispatch: Dispatch
    public let getState: () -> T
    public let subscribe: (onNext: (T) -> Void) -> Disposable

    public init(dispatch: Dispatch, getState: () -> T, subscribe: (onNext: (T) -> Void) -> Disposable){
        self.dispatch = dispatch
        self.getState = getState
        self.subscribe = subscribe
    }
}
