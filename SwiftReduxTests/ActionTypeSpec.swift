//
//  StoreTypeTest.swift
//  SwiftRedux
//
//  Created by Aleksander Herforth Rendtslev on 06/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

import Quick
import Nimble
import RxSwift
@testable import SwiftRedux


class ActionTypeSpec: QuickSpec {
    
    
    override func spec(){
        
        describe("ActionTypeSpec"){
            
            beforeEach{
            }
            
            
            it("should succesfully retrieve payload from actionType"){
                
                // Arrange
                let incrementAction = IncrementAction() as Action
                let pushAction = PushAction(payload: nil) as Action
                let updateTextFieldAction = UpdateTextFieldAction(payload: nil) as Action
                
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