//
//  Action.swift
//  ReduxKit
//
//  Created by Aleksander Herforth Rendtslev on 03/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

/**
 Basic action structure
 */
public protocol Action {}

public extension Action {

    /// Computed property that automatically fetches the actionType from the current action
    public var type: String { return "\(self.dynamicType.self)" }
}
