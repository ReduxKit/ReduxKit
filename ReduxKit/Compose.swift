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


public class F<T1, T2> {
    
    let f: T1 -> T2
    
    public init(function: T1 -> T2) {
        self.f = function
    }
    
    func run(args: T1) -> T2 {
        return f(args)
    }
}

public func +<T1, T2>(beforeHook: F<(), ()>, function: F<T1, T2>) -> (T1 -> T2) {
    
    func composedFunc(args: T1) -> T2 {
        beforeHook.run()
        return function.run(args)
    }
    
    return composedFunc
}

public func +<T1, T2>(function: F<T1, T2>, afterHook: F<T2, ()>) -> (T1 -> T2) {
    
    func composedFunc(args: T1) -> T2 {
        let result = function.run(args)
        afterHook.run(result)
        return result
    }
    
    return composedFunc
}