//
//  ActionSpec.swift
//  ReduxKit
//
//  Created by Karl Bowden on 9/01/2016.
//  Copyright © 2016 Kare Media. All rights reserved.
//

import Quick
import Nimble
@testable import ReduxKit

class ActionSpec: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable nesting
    override func spec() {

        let expectedString = "expectedString"

        struct TestState {
            let value: String
        }

        func testReducer(state: TestState? = nil, action: Action) -> TestState {
            return state ?? TestState(value: expectedString)
        }

        var store: Store<TestState>!

        beforeEach {
            store = createStore(testReducer, state: nil)
        }

        describe("Action protocol conformance") {

            context("enum action") {
                it("should dispatch enums that conform to Action") {
                    // Arrange
                    enum MyAction: Action { case Default }

                    // Act
                    store.dispatch(MyAction.Default)

                    // Assert
                    expect(store.getState().value).to(equal(expectedString))
                }
            }

            context("struct action") {
                it("should dispatch structs that conform to Action") {
                    // Arrange
                    struct MyAction: Action {}

                    // Act
                    store.dispatch(MyAction())

                    // Assert
                    expect(store.getState().value).to(equal(expectedString))
                }
            }

            context("class action") {
                it("should dispatch classes that conform to Action") {
                    // Arrange
                    class MyAction: Action {}

                    // Act
                    store.dispatch(MyAction())

                    // Assert
                    expect(store.getState().value).to(equal(expectedString))
                }
            }
        }

        describe("Action.type") {

            // Arrange
            struct MyAction: Action {}
            let expectedTypeContent = "MyAction"

            it("should be a string") {
                // Act
                let actualType = MyAction().type

                // Assert
                expect(actualType is String).to(beTruthy())
            }

            it("should contains the type name") {
                // Act
                let actualType = MyAction().type

                // Assert
                expect(actualType).to(contain(expectedTypeContent))
            }

            it("should stay the same across instances") {
                // Act
                let firstType = MyAction().type
                let secondType = MyAction().type

                // Assert
                expect(firstType).to(equal(secondType))
            }
        }
    }
}
