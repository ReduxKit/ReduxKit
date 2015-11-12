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
                let incrementAction = Action<IncrementAction>() as ActionType
                let pushAction = Action<PushAction>() as ActionType
                let updateTextFieldAction = Action<UpdateTextFieldAction>() as ActionType
                
                // Act
                let incrementPayload = incrementAction.getPayload()
                let pushPayload = pushAction.getPayload()
                let updateTextFieldPayload = updateTextFieldAction.getPayload()
                
                // Assert
                expect(incrementPayload is Int).to(beTruthy())
                expect(pushPayload is PushAction.Payload).to(beTruthy())
                expect(updateTextFieldPayload is UpdateTextFieldAction.Payload).to(beTruthy())
                
            }
        }
    }
    
}