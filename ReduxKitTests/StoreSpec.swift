//
//  StoreSpec.swift
//  ReduxKit
//
//  Created by Karl Bowden on 9/01/2016.
//  Copyright © 2016 Kare Media. All rights reserved.
//

import Quick
import Nimble
@testable import ReduxKit

class StoreSpec: QuickSpec {

    override func spec() {

        describe("StoreSpec") {

            it("should dispatch actions that conform to Action") {
                // Arrange
                let expectedString = "expectedString"
                struct TestState {
                    let value: String
                }
                func testReducer(state: TestState? = nil, action: Action) -> TestState {
                    return state ?? TestState(value: expectedString)
                }
                let store = createStore(testReducer, state: nil)

                // Act
                class MyAction: Action {}
                store.dispatch(MyAction())

                // Assert
                expect(store.getState().value).to(equal(expectedString))
            }
        }
    }
}
