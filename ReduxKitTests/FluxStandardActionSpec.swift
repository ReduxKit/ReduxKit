//
//  FluxStandardActionSpec.swift
//  ReduxKit
//
//  Created by Aleksander Herforth Rendtslev on 06/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

import Quick
import Nimble
@testable import ReduxKit

class FluxStandardActionSpec: QuickSpec {

    override func spec() {

        describe("FluxStandardActionSpec") {

            // swiftlint:disable line_length
            it("should succesfully retrieve payload from FluxStandardAction types") {

                // Arrange
                let incrementAction = IncrementAction() as FluxStandardAction
                let pushAction = PushAction(payload: nil) as FluxStandardAction
                let updateTextFieldAction = UpdateTextFieldAction(payload: nil) as FluxStandardAction

                // Act
                let incrementPayload = incrementAction.payload
                let pushPayload = pushAction.payload
                let updateTextFieldPayload = updateTextFieldAction.payload

                // Assert
                expect(incrementPayload is Int).to(beTruthy())
                expect(pushPayload is PushAction.Payload).to(beTruthy())
                expect(updateTextFieldPayload is UpdateTextFieldAction.Payload).to(beTruthy())
            }
        }
    }
}
