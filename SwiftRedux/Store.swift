
//
//  StoreTYpe.swift
//  SwiftRedux
//
//  Created by Aleksander Herforth Rendtslev on 03/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

import RxSwift

public typealias Dispatch = Action -> Action

/**
 *  Store protocol.
 */
public protocol Store{
    var dispatch: Dispatch {get}
    var getState: () -> State {get}
    var subscribe: (onNext: (State) -> Void) -> Disposable {get}
}

/**
 *  Standard store
 */
public struct StandardStore : Store{
    public var dispatch: Dispatch
    public let getState: () -> State
    public let subscribe: (onNext: (State) -> Void) -> Disposable
}

/**
 *  TypedStore
 *  It removes the necessity of casting the state object everytime subscribe is called
 */
public struct TypedStore<T where T:State>{
    let dispatch: Dispatch
    let getState: () -> T
    let subscribe: (onNext: (T) -> Void) -> Disposable
}