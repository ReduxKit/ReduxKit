//
//  SimpleStandardAction.swift
//  ReduxKit
//
//  Created by Karl Bowden on 9/01/2016.
//  Copyright © 2016 Kare Media. All rights reserved.
//

/**
 This is the StandardAction which is the recommended protocol to use when implementing actions.

 It is generic and expects a rawPayload of a generic type.
 */
public protocol SimpleStandardAction: FluxStandardAction {

    typealias PayloadType

    var rawPayload: PayloadType { get }
}

public extension SimpleStandardAction {

    /// Default implementation for payload
    public var payload: Any? { return rawPayload }
}
