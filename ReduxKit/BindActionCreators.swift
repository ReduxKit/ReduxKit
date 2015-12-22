//
//  BindActionCreators.swift
//  ReduxKit
//
//  Created by Aleksander Herforth Rendtslev on 09/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//



/**
 Helper function that helps create shorthand dispatch functions. It requires a
 StandardAction with a valid initializer to function.

 - parameter type:
 - parameter dispatch:
*/
public func bindActionCreators<Action where Action: StandardAction>(type: Action.Type, dispatch: Dispatch)
    -> (payload: Action.PayloadType?)
    -> () {

    func innerBind(payload: Action.PayloadType? = nil) {

        let action = Action(payload: payload, meta: nil, error: false)

        dispatch(action)
    }

    return innerBind
}
