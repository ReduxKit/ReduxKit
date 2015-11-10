//
//  StoreTypeTest.swift
//  SwiftRedux
//
//  Created by Aleksander Herforth Rendtslev on 06/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

import XCTest
import Quick
import Nimble
import RxSwift
@testable import SwiftRedux


class CreateStoreSpec: QuickSpec {
    

    override func spec(){
        
        describe("Create Store"){
            var defaultState: AppState!
            var store: Store<AppState>!
            
            beforeEach{
                defaultState = applicationReducer(action:Action<DefaultAction>())
                store = createStore(applicationReducer, initialState: defaultState)
            }
            
            
            it("should be subscribable and succesfully propagate one action dispatch"){
                
                // Arrange
                var state: AppState!
                
                
                // Act
                store.subscribe{ newState in
                    state = newState
                }
                
                
                store.dispatch(action: Action<IncrementAction>())
                
                // Assert
                expect(state.counter).toNot(equal(defaultState.counter))
                expect(state.counter).to(equal(defaultState.counter+1))
            }
            
            it("should effectively run multiple dispatches"){
                // Arrange
                var state: AppState!
                let iterations = 3
                
                // Act
                store.subscribe{ newState in
                    state = newState
                }
                
                // Run dispatch multiple times
                for(var i = 0; i < iterations; i++){
                    store.dispatch(action: Action<IncrementAction>())
                }

                
                // Assert
                expect(state.counter).toNot(equal(defaultState.counter))
                expect(state.counter).to(equal(defaultState.counter+iterations))
            
            
            }
            
            it("should work with multiple reducers"){
                // Arrange
                var state: AppState!
                let textMessage = "test"
                let iterations = 3
                
                store.subscribe{ newState in
                    state = newState
                }
                
                for(var i = 0; i < iterations; i++){
                    store.dispatch(action: Action<IncrementAction>())
                    store.dispatch(action: Action<PushAction>(payload: PushAction.Payload(text: textMessage)))
                    store.dispatch(action: Action<UpdateTextFieldAction>(payload: UpdateTextFieldAction.Payload(text: textMessage)))
                }
                
                // Assert
                expect(state.counter).to(equal(defaultState.counter+iterations))
                expect(state.countries).to(contain(textMessage))
                expect(state.countries.count).to(equal(iterations))
                expect(state.textField.value).to(equal(textMessage))
            }
        }
    }
    
}