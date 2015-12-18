//
//  Disposable.swift
//  Redux
//
//  Created by Karl Bowden on 16/12/2015.
//  Copyright © 2015 Kare Media. All rights reserved.
//

public protocol ReduxDisposable {

    var disposed: Bool { get }

    var dispose: () -> () { get }
}

public struct SimpleReduxDisposable: ReduxDisposable {

    let _disposed: () -> Bool

    public var disposed: Bool { return _disposed() }

    public let dispose: () -> ()

    public init(disposed: () -> Bool, dispose: () -> ()) {
        _disposed = disposed
        self.dispose = dispose
    }
}
