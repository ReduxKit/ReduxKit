//
//  ApplyMiddlewaresSpec.swift
//  SwiftRedux
//
//  Created by Aleksander Herforth Rendtslev on 10/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

import Quick
import Nimble
@testable import SwiftRedux

class ApplyMiddlewaresSpec: QuickSpec {

    override func spec(){

        describe("ApplyMiddlewares"){
            var defaultState: AppState!
            var store: TypedStore<AppState>!

            beforeEach{
                defaultState = applicationReducer(action:DefaultAction()) as! AppState
            }

            it("should succesfully call dispatch and pass responses through a logger"){

                // Arrange
                store = createTypedStore([
                    applyMiddlewares([
                        firstPushMiddleware
                        ])
                    ])(createStore)(applicationReducer, nil)

                var state: AppState!
                store.subscribe{ newState in
                    state = newState
                }

                // Act
                store.dispatch(PushAction(payload: PushAction.Payload(text:"")))

                // Assert
                expect(state.countries).to(contain(".first"))
            }

            it("should succesfully call dispatch and pass responses through multiple loggers"){

                // Arrange
                store = createTypedStore([
                    applyMiddlewares([
                        firstPushMiddleware,
                        secondaryPushMiddleware
                        ])
                    ])(createStore)(applicationReducer, nil)

                var state: AppState!
                store.subscribe{ newState in
                    state = newState
                }

                // Act
                store.dispatch(PushAction(payload: PushAction.Payload(text:"")))

                // Assert
                expect(state.countries).to(contain(".first.secondary"))
            }

            it("should retravel the whole chain and increment"){

                // Arrange
                store = createTypedStore([
                    applyMiddlewares([
                        firstPushMiddleware,
                        reTravelMiddleware,
                        firstPushMiddleware
                        ])
                    ])(createStore)(applicationReducer, nil)

                var state: AppState!

                store.subscribe{ newState in
                    state = newState
                }

                // Act
                store.dispatch(ReTravelAction())

                // Assert
                expect(state.counter).toNot(equal(defaultState.counter))
                expect(state.counter).to(equal(1))
            }
        }
    }
}
