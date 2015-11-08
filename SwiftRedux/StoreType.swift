
//
//  StoreTYpe.swift
//  SwiftRedux
//
//  Created by Aleksander Herforth Rendtslev on 03/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

import RxSwift

protocol StoreType{
    typealias Type
    func getState() -> StateType
}

 /// Central applicaiton store
 class Store<T where T:StateType>: StoreType{
    typealias Type = T
    
    private var currentReducer: (ActionType, Type) -> Type
    private var currentState: Type
    private let subjectDispatcher: BehaviorSubject<Type>
    private let stateSubject = ReplaySubject<Type>.create(bufferSize: 1)
    private var middlewares: [(store: Store<Type>)-> ActionType]?
    
    /**
     Initializer
     
     - parameter reducer:      main reducer.
     - parameter initialState: The apps initialState
     */
    init(reducer: (ActionType, Type) -> Type, initialState: Type){
        
        currentState = initialState
        currentReducer = reducer
        subjectDispatcher = BehaviorSubject(value: initialState)
        
        // Subscribe the ReplaySubject to the subjectDispatcher.
        subjectDispatcher.subscribe(stateSubject)
        
    }
    
    /**
     Convenience initializer that will set the middlerewares as well.
     
     - parameter reducer:      Main reducer
     - parameter initialState: The apps initialState
     - parameter middleWares:  An array of middlewares
     */
    convenience init(reducer: (ActionType, Type) -> Type, initialState: Type, middlewares: [(store: Store<Type>)->ActionType]){
        self.init(reducer: reducer, initialState:initialState)
        
        self.middlewares = middlewares
    }

    /**
     Will get the current state from the store
     
     - returns: the current state
     */
    func getState() -> StateType {
        return currentState
    }
    

    
    
}



/**
 *  The store should be dispatchable
 */
protocol Dispatchable{
    func dispatch(action: ActionType) -> ActionType
}

// MARK: - Dispatchable
extension Store: Dispatchable{
    
    func dispatch(action: ActionType) -> ActionType{
        
        
        if(middlewares != nil){
            middlewares!.map{ middleware in
                middleware(store: self)
            }
        }
        
        currentState = currentReducer(action, currentState)
        subjectDispatcher.onNext(currentState);
        
        return action
    }
    
    /**
     Will trigger onNext notifying al subscribers of the change
     
     - parameter action: the given Action
     
     - returns: the given action
     */
    private func innerDispatch(action: ActionType) -> ActionType{
        subjectDispatcher.onNext(currentState);
        
        return action
    }
}



/**
 *  The store should be subscribable
 */
protocol Subscribable{
    typealias Type
    func subscribe(onNext: (Type) -> Void) -> Disposable
}

// MARK: - Subscribable
extension Store: Subscribable{
    /**
     Will subscribe to the stateSubjects onNext function
     
     - parameter onNext: Subscribe function
     
     - returns: will return the stateSubjects onNext function
     */
    func subscribe(onNext: (Type) -> Void) -> Disposable{
        return stateSubject.subscribeNext(onNext)
    }
}