//
//  Reducer.swift
//  SwiftRedux
//
//  Created by Aleksander Herforth Rendtslev on 19/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//


public typealias Reducer = (state: State?, action: Action) -> State


public enum ReducerErrors: ErrorType{
    case StateTypeError
}