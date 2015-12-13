//
//  Disposable.swift
//  SwiftRedux
//
//  Created by Karl Bowden on 14/12/2015.
//  Copyright © 2015 Kare Media. All rights reserved.
//

public protocol Disposable {
    var isDisposed: Bool { get }
    func dispose()
}
