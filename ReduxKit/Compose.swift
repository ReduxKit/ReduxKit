//
//  Compose.swift
//  ReduxKit
//
//  Created by Karl Bowden on 17/12/2015.
//  Copyright © 2015 Kare Media. All rights reserved.
//

public func compose<T>(objects: [(T) -> T]) -> (T) -> T {
    return { (arg: T) -> T in
        objects.reverse().reduce(arg) { (composed: T, f: (T) -> T) -> T in
            f(composed)
        }
    }
}
