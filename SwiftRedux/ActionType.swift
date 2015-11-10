//
//  ActionType.swift
//  SwiftRedux
//
//  Created by Aleksander Herforth Rendtslev on 03/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//






public protocol Payloadable{
    typealias PayloadType
    static var defaultValue: PayloadType {get}
}


public protocol Failable{
    var error: String? {get set}
}

public struct DefaultAction: Payloadable{
    public typealias PayloadType = Any?
    public static var defaultValue:PayloadType = nil
}

public protocol ActionType{
    var type: String {get}
}

struct Action<T where T:Payloadable>: ActionType{
    typealias Type = T
    var type = "\(Type.self)"
    let payload: T.PayloadType
    let error: String?
    
    
    init(payload: T.PayloadType = T.defaultValue, error: String? = nil){
        self.payload = payload
        self.error = error
    }
}

func test(){
    let test2 = Action<DefaultAction>(payload: nil)
    print(test2)
}