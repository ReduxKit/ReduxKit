
//
//  StoreTYpe.swift
//  SwiftRedux
//
//  Created by Aleksander Herforth Rendtslev on 03/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

import RxSwift

public typealias DispatchFunction = (action: ActionType) -> ActionType


public struct Store<T where T:StateType>{
    public typealias Reducer = (ActionType, T) -> T
    
    public let dispatch: DispatchFunction
    public let getState: () -> T
    public let subscribe: (onNext: (T) -> Void) -> Disposable
     //public let replaceReducer: (Reducer)
}