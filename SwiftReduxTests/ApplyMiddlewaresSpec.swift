//
//  ApplyMiddlewaresSpec.swift
//  SwiftRedux
//
//  Created by Aleksander Herforth Rendtslev on 10/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//


import Quick
import Nimble
import RxSwift
@testable import SwiftRedux

class ApplyMiddlewaresSpec: QuickSpec {
    
    
    override func spec(){
        
        describe("ApplyMiddlewares"){
            var defaultState: AppState!
            var store: Store<AppState>!
            
            beforeEach{
                defaultState = applicationReducer(action:Action<DefaultAction>())
                
            }
            
            
            it("should succesfully call dispatch and pass responses through a logger"){
                
                // Arrange
                store = applyMiddlewares([
                    firstPushMiddleware
                    ])(createStore)(applicationReducer, defaultState)
                var state: AppState!
                store.subscribe{ newState in
                    state = newState
                }
                
                // Act
                store.dispatch(action: Action<PushAction>(payload: PushAction.Payload(text:"")))
                
                // Assert
                expect(state.countries).to(contain(".first"))
            }
            
            it("should succesfully call dispatch and pass responses through multiple loggers"){
                
                // Arrange
                store = applyMiddlewares([
                    firstPushMiddleware,
                    secondaryPushMiddleware
                    ])(createStore)(applicationReducer, defaultState)
                var state: AppState!
                store.subscribe{ newState in
                    state = newState
                }
                
                // Act
                store.dispatch(action: Action<PushAction>(payload: PushAction.Payload(text:"")))
                
                // Assert
                expect(state.countries).to(contain(".first.secondary"))
            }
            
        }
    }
    
}