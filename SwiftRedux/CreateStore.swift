//
//  CreateStore.swift
//  SwiftRedux
//
//  Created by Aleksander Herforth Rendtslev on 09/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

import RxSwift



public func createStore<T where T:StateType>(reducer: (T, ActionType)-> T, initialState: T) -> Store<T>{
    
    var currentReducer: (T, ActionType) -> T = reducer
    var currentState: T = initialState
    let subjectDispatcher: PublishSubject<ActionType> = PublishSubject()
    let stateSubject = ReplaySubject<T>.create(bufferSize: 1)
    var isDispatching = false
    
    // have the stateSubject subscribe to the dispatcher
    subjectDispatcher
        .scan(initialState, accumulator: reducer)
        .startWith(initialState)
        .subscribe(stateSubject)
    
    //var middlewares: [(store: Store<T>)-> ActionType]?
    
    
    /**
    Will dispatch the given action to both reducers and middlewares
    
    - parameter action: the given action - that conforms to the protocol ActionType
    
    - returns: will return the action
    */
    func dispatch(action: ActionType) -> ActionType{
        do{
            try innerDispatch(action)
        }catch{
            print("Error dispatching. Are you dispatching from a reducer?")
        }
        
        return action
    }
    
    /**
     Will return the current state
     
     - returns: currentState
     */
    func getState() -> T{
        return currentState
    }
    
    /**
     Will trigger onNext notifying al subscribers of the change
     
     - parameter action: the given Action
     
     - returns: the given action
     */
    func innerDispatch(action: ActionType) throws -> ActionType{
        
        /**
        *  the previous dispatch should be completed before the next one is initiated.
        */
        if(isDispatching) {
            throw StoreErrors.DispatchError
        }
        
        /**
        *  When the function is done running, reset the isDispatching variable
        */
        defer{
            isDispatching = false
        }
        
        isDispatching = true
        subjectDispatcher.onNext(action);
        
        return action
    }
    
    /**
     Will subscribe to the stateSubjects onNext function
     
     - parameter onNext: Subscribe function
     
     - returns: will return the stateSubjects onNext function
     */
    func subscribe(onNext: T -> Void) -> Disposable{
        return stateSubject.subscribeNext(onNext)
    }
    
    return Store(dispatch: dispatch, getState: getState, subscribe: subscribe)

}