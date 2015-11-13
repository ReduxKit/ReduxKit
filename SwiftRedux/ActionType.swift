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
    static var defaultError: String {get}
}

public struct DefaultAction: Payloadable{
    public typealias PayloadType = Any?
    public static var defaultValue:PayloadType = nil
}

public protocol ActionType{
    var type: String {get}
    var payloadType: String {get}
    func getPayload() -> Any?
}

public struct Action<T where T:Payloadable>: ActionType{
    public typealias Type = T
    public var type = "\(Type.self)"
    public var payloadType = "\(Type.PayloadType.self)"
    public let payload: T.PayloadType
    public var error: String?


    public init(payload: T.PayloadType = T.defaultValue){
        self.payload = payload
    }
    
    public func getPayload() -> Any? {
        return payload as Any?
    }
}

public extension Action where T:Failable{
    public init(payload: T.PayloadType = T.defaultValue, error: String = T.defaultError){
        self.init(payload:payload)
        self.error = error
    }
}