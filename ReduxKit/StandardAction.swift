//
//  StandardAction.swift
//  ReduxKit
//
//  Created by Karl Bowden on 9/01/2016.
//  Copyright © 2016 Kare Media. All rights reserved.
//

/**
 Optional protocol used for when actions have to be created generically

 It requires a initializer to be present
 */
public protocol StandardAction: SimpleStandardAction {

    init(payload: PayloadType?, meta: Any?, error: Bool)
}
