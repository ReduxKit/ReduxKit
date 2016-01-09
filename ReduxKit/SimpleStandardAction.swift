//
//  SimpleStandardAction.swift
//  ReduxKit
//
//  Created by Karl Bowden on 9/01/2016.
//  Copyright © 2016 Kare Media. All rights reserved.
//

/**
 The SimpleStandardAction contains a strongly typed rawPayload property. It is generic and expects
 a rawPayload of a generic type.

 The protocol automatically assigns the rawPayload to the Actions payload property. This removes
 the necessity of type casting whenever working with actions in a reducer.

 There's also the StandardAction protocol, that requires the struct to have an initializer. This is
 required if the bindActionCreators helper is to be used.
 */
public protocol SimpleStandardAction: FluxStandardAction {

    typealias PayloadType

    var rawPayload: PayloadType { get }
}

public extension SimpleStandardAction {

    /// Default implementation for payload
    public var payload: Any? { return rawPayload }
}
