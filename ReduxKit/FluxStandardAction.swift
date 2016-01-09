//
//  FluxStandardAction.swift
//  ReduxKit
//
//  Created by Karl Bowden on 9/01/2016.
//  Copyright © 2016 Kare Media. All rights reserved.
//


/**
 Basic action structure
 */
public protocol FluxStandardAction: Action {

    var type: String { get }

    var payload: Any? { get }

    var meta: Any? { get }

    var error: Bool { get }
}
