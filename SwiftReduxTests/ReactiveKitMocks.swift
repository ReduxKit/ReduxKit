//
//  ReactiveKitMocks.swift
//  SwiftRedux
//
//  Created by Karl Bowden on 15/12/2015.
//  Copyright © 2015 Kare Media. All rights reserved.
//

import SwiftRedux
import ReactiveKit

func createReactiveKitStream<State>(state: State) -> StateStream<State, DisposableType> {
    let observable = Observable(state)
    return StateStream(next: observable.next, observe: { observable.observe(observer: $0) }, latest: { observable.value })
}
