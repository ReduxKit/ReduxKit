//
//  ApplyMiddlewaresSpec.swift
//  ReduxKit
//
//  Created by Aleksander Herforth Rendtslev on 10/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

import Quick
import Nimble
@testable import ReduxKit

class ApplyMiddlewaresSpec: QuickSpec {

    // swiftlint:disable function_body_length
    override func spec() {

        describe("ApplyMiddlewares") {
            let defaultState = applicationReducer(action: DefaultAction())
            var store: Store<AppState>!

            it("should succesfully call dispatch and pass responses through a logger") {
                // Arrange
                store = applyMiddleware([
                    firstPushMiddleware
                    ])(createStore)(applicationReducer, nil)

                var state: AppState!
                store.subscribe { state = $0 }

                // Act
                store.dispatch(PushAction(payload: PushAction.Payload(text:"")))

                // Assert
                expect(state.countries).to(contain(".first"))
            }

            it("should succesfully call dispatch and pass responses through multiple loggers") {
                // Arrange
                store = applyMiddleware([
                    firstPushMiddleware,
                    secondaryPushMiddleware
                    ])(createStore)(applicationReducer, nil)

                var state: AppState!
                store.subscribe { state = $0 }

                // Act
                store.dispatch(PushAction(payload: PushAction.Payload(text:"")))

                // Assert
                expect(state.countries).to(contain(".first.secondary"))
            }

            it("should retravel the whole chain and increment") {
                // Arrange
                store = applyMiddleware([
                    firstPushMiddleware,
                    reTravelMiddleware,
                    firstPushMiddleware
                    ])(createStore)(applicationReducer, nil)

                var state: AppState!
                store.subscribe { state = $0 }

                // Act
                store.dispatch(ReTravelAction())

                // Assert
                expect(state.counter).toNot(equal(defaultState.counter))
                expect(state.counter).to(equal(store.state.counter))
                expect(state.counter).to(equal(1))
            }
        }
    }
}
