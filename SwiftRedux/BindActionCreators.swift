//
//  BindActionCreators.swift
//  SwiftRedux
//
//  Created by Aleksander Herforth Rendtslev on 09/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//




public func bindActionCreators<T where T:Payloadable>(type: T.Type, dispatch: DispatchFunction) -> (payload: T.PayloadType?) -> Void{
    return{(payload: T.PayloadType?) in
        
        let action = payload != nil ? Action<T>(payload: payload!) : Action<T>()
        dispatch(action: action)
    }
}