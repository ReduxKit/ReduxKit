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


class StoreTypeSpec: QuickSpec {
    

    override func spec(){
        
        describe("The store"){
            var defaultState: BaseState!
            var store: Store<BaseState>!
            
            beforeEach{
                defaultState = ApplicationReducer(DefaultAction(), state: nil)
                store = Store(reducer: ApplicationReducer, initialState: defaultState)
            }
            
            
            it("should be subscribable and succesfully propagate one action dispatch"){
                
                // Arrange
                var state: BaseState!
                
                
                // Act
                store.subscribe{ newState in
                    state = newState
                }
                
                store.dispatch(IncrementAction())
                
                
                // Assert
                expect(state.counter).toNot(equal(defaultState.counter))
                expect(state.counter).to(equal(defaultState.counter+1))
            }
            
            it("should effectively run multiple dispatches"){
                // Arrange
                var state: BaseState!
                let iterations = 3
                
                // Act
                store.subscribe{ newState in
                    state = newState
                }
                
                // Run dispatch multiple times
                for(var i = 0; i < iterations; i++){
                    store.dispatch(IncrementAction())
                }

                
                // Assert
                expect(state.counter).toNot(equal(defaultState.counter))
                expect(state.counter).to(equal(defaultState.counter+iterations))
            
            
            }
            
            it("should work with multiple reducers"){
                // Arrange
                var state: BaseState!
                let textMessage = "test"
                let iterations = 3
                
                store.subscribe{ newState in
                    state = newState
                }
                
                for(var i = 0; i < iterations; i++){
                    store.dispatch(IncrementAction())
                    store.dispatch(PushAction(text: textMessage))
                    store.dispatch(UpdateTextFieldAction(text: textMessage))
                }
                
                print(state.countries.count)
                // Assert
                expect(state.counter).to(equal(defaultState.counter+iterations))
                expect(state.countries).to(contain(textMessage))
                expect(state.countries.count).to(equal(iterations))
                expect(state.textField.value).to(equal(textMessage))
            
            }
        }
    }
    
}