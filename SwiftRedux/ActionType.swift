//
//  ActionType.swift
//  SwiftRedux
//
//  Created by Aleksander Herforth Rendtslev on 03/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//


protocol ActionType{
  
}

protocol Payloadable{
  typealias PayloadType
  var payload: PayloadType {get set}
}

protocol Failable{
    var error: String? {get set}
}


struct DefaultAction: ActionType{
    var payload: Any?;
}


protocol ReducerType{
    func reduce(statePlaceholder:Any, action:ActionType) ->Any
}