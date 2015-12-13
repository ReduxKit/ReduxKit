//
//  StateStream.swift
//  SwiftRedux
//
//  Created by Karl Bowden on 14/12/2015.
//  Copyright © 2015 Kare Media. All rights reserved.
//

public struct StateStream<T> {

    public let publish: T -> ()
    public let subscribe: (T -> ()) -> Disposable
    public let getState: () -> T
}
