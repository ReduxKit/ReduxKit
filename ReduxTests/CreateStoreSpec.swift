//
//  CreateStoreSpec.swift
//  Redux
//
//  Created by Aleksander Herforth Rendtslev on 06/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

import Quick
import Nimble
@testable import Redux

class CreateStoreSpec: QuickSpec {

    override func spec() {

        describe("Create Store") {
            var defaultState: AppState!
            var store: Store<AppState>!

            beforeEach {
                store = createStore(applicationReducer, state: nil)
                defaultState = store.state
            }

            it("should be subscribable and succesfully propagate one action dispatch") {
                // Arrange
                var state: AppState!

                // Act
                store.subscribe { state = $0 }

                store.dispatch(IncrementAction())

                // Assert
                expect(state.counter).toNot(equal(defaultState.counter))
                expect(state.counter).to(equal(defaultState.counter + 1))
            }

            it("should effectively run multiple dispatches") {
                // Arrange
                var state: AppState!
                let iterations = 3
                store.subscribe { state = $0 }

                // Act: Run dispatch multiple times
                for var i = 0; i < iterations; i++ {
                    store.dispatch(IncrementAction())
                }

                // Assert
                expect(state.counter).toNot(equal(defaultState.counter))
                expect(state.counter).to(equal(defaultState.counter + iterations))
            }

            it("should fetch the latest state") {
                // Arrange
                var state: AppState!

                // Act: Run dispatch multiple times
                store.dispatch(IncrementAction())
                state = store.state

                // Assert
                expect(state.counter).toNot(equal(defaultState.counter))
            }

            it("should work with multiple reducers") {
                // Arrange
                var state: AppState!
                let textMessage = "test"
                let iterations = 3
                store.subscribe { state = $0 }

                // Act
                for var i = 0; i < iterations; i++ {
                    store.dispatch(IncrementAction())
                    store.dispatch(PushAction(payload: PushAction.Payload(text: textMessage)))
                    store.dispatch(UpdateTextFieldAction(payload: UpdateTextFieldAction.Payload(text: textMessage)))
                }

                // Assert
                expect(state.counter).to(equal(defaultState.counter + iterations))
                expect(state.countries).to(contain(textMessage))
                expect(state.countries.count).to(equal(iterations))
                expect(state.textField.value).to(equal(textMessage))
            }
        }
    }
}
