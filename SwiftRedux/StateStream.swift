//
//  StateStream.swift
//  SwiftRedux
//
//  Created by Karl Bowden on 14/12/2015.
//  Copyright © 2015 Kare Media. All rights reserved.
//

/**

StateStream is the layer between reactive frameworks and SwiftRedux in order to
produce States served by your perfered framework.

There is no default StateStream provided by SwiftRedux.

*/
public struct StateStream<State, Disposable> {

    public let next: State -> ()
    public let observe: (State -> ()) -> Disposable
    public let latest: () -> State

    public init(next: State -> (), observe: (State -> ()) -> Disposable, latest: () -> State) {
        self.next = next
        self.observe = observe
        self.latest = latest
    }
}
