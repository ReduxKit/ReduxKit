//
//  MiddlewareApiSpec.swift
//  ReduxKit
//
//  Created by Karl Bowden on 28/12/2015.
//  Copyright © 2015 Kare Media. All rights reserved.
//

import Quick
import Nimble
@testable import ReduxKit

class MiddlewareApiSpec: QuickSpec {

    override func spec() {

        describe("MiddlewareApiSpec") {

            it("should accept a dispatch and getState") {
                // Arrange
                let dispatch: Dispatch = { $0 }
                let getState: () -> AppState = {
                    AppState(counter: 1, countries: [], textField: TextFieldState(value: "YES"))
                }

                // Act
                let middlewareApi = MiddlewareApi(dispatch: dispatch, getState: getState)
                let dispatchedAction = middlewareApi.dispatch(IncrementAction())
                let state = middlewareApi.getState()

                // Assert
                expect(dispatchedAction.type).to(equal("IncrementAction"))
                expect(state.counter).to(equal(1))
            }
        }
    }
}
