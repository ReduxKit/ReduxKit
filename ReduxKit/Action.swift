//
//  Action.swift
//  ReduxKit
//
//  Created by Aleksander Herforth Rendtslev on 03/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

// MARK: Action protocol

/**
 Base action type all actions must conform to.

 The Action protocol is intentionally minimal to allow Action types to best fit their situation.

 If there are common properties needed on all Action types in you app, the Action protocol can be
 extended and each action can inherit from the new protocol instead. See FluxStandardAction for a
 good example of this in practice.
 */
public protocol Action {}

public extension Action {

    /// Computed property that automatically fetches the actionType from the current action
    public var type: String { return "\(self.dynamicType.self)" }
}
