//
//  BindActionCreators.swift
//  SwiftRedux
//
//  Created by Aleksander Herforth Rendtslev on 09/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//



/**
Helper function that helps create shorthand dispatch functions. It requires a StandardAction with a valid initializer to function

- parameter type:
- parameter dispatch:
*/
public func bindActionCreators<T where T:StandardAction>(type: T.Type, dispatch: Dispatch) -> (payload: T.PayloadType?) -> Void{
    
    func innerBind(payload: T.PayloadType? = nil){
        
        let action = T(payload: payload, meta: nil, error: false)
        
        dispatch(action)
    }
    
    return innerBind
}