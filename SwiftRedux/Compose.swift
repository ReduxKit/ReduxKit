//
//  Compose.swift
//  SwiftRedux
//
//  Created by Aleksander Herforth Rendtslev on 10/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//


public func compose<T>(objects: [(T) -> T]) -> (T) -> T{
    let reversed = objects.reverse()

    func compose(arg: T) -> T{

        return reversed.reduce(arg) { (composed: T, f: (T) -> T) -> T in
            return f(composed)
        }
    }

    return compose

}
