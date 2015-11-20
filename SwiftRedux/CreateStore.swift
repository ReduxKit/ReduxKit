//
//  CreateStore.swift
//  SwiftRedux
//
//  Created by Aleksander Herforth Rendtslev on 09/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

import RxSwift


/**
 Helper chain function that takes a StoreCreator and creates a TypedStore
 While this could have been a regular storeEnhancer, the current compose function expects the return type to be the same as the parameter type. So as it is
 now it doesn't work as seen on ReduxJs and need to be put first in the chain.
 
 - parameter storeEnhancers: storeEnhancers description
 
 - returns: return value description
 */
public func createTypedStore<T where T:State>(storeEnhancers: [StoreEnhancer] = []) -> (StoreCreator) -> (Reducer, State?) -> TypedStore<T>{
    
    return  { (next:StoreCreator) -> (Reducer, State?) -> TypedStore<T> in
        return { (reducer: Reducer, initialState: State?) -> TypedStore<T> in
            
            /// Will apply all storeEnhancers before applying the store creator
            let storeCreator = compose(storeEnhancers)(next)
            
            /// Will create a store with the compounded storeCreator
            let store = storeCreator(reducer: reducer, initialState: initialState)
            
            return convertStoreToTypedStore(store)
        }
        
    }
}

/**
 Helper function that converts a store complying to the Store protocol to a typed store.
 
 - parameter store: a store complying to the Store interface
 
 - returns: TypedStore<T>
 */
public func convertStoreToTypedStore<T where T:State>(store: Store) -> TypedStore<T>{
    return TypedStore(
        dispatch: store.dispatch,
        getState: { () -> T in
            return store.getState() as! T
        },
        subscribe: {(onNext: (T) -> Void) -> Disposable in
            return store.subscribe{(state: State) -> Void in
                onNext(state as! T)
            }
        }
    )
}

/**
 Will create a store with the state specified as
 
 - parameter reducer:      reducer description
 - parameter action:       action description
 - parameter initialState: initialState description
 
 - returns: return value description
 */
public func createStore(reducer: Reducer, initialState: State?) -> Store{
    var currentReducer: Reducer = reducer
    var currentState: State = (initialState != nil) ? initialState! : reducer(state: initialState,action:DefaultAction())
    let subjectDispatcher: PublishSubject<Action> = PublishSubject()
    let stateSubject = ReplaySubject<State>.create(bufferSize: 1)
    var isDispatching = false
    
    // have the stateSubject subscribe to the dispatcher
    subjectDispatcher
        .scan(currentState, accumulator: reducer)
        .startWith(currentState)
        .subscribe(stateSubject)
    
    //var middlewares: [(store: Store)-> ActionType]?
    
    
    /**
    Will dispatch the given action to both reducers and middlewares
    
    - parameter action: the given action - that conforms to the protocol ActionType
    
    - returns: will return the action
    */
    func dispatch(action: Action) -> Action{
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
    func getState() -> State{
        return currentState
    }
    
    /**
     Will trigger onNext notifying al subscribers of the change
     
     - parameter action: the given Action
     
     - returns: the given action
     */
    func innerDispatch(action: Action) throws -> Action{
        
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
    func subscribe(onNext: State -> Void) -> Disposable{
        return stateSubject.subscribeNext(onNext)
    }
    
    return StandardStore(dispatch: dispatch, getState: getState, subscribe: subscribe)

}


public enum StoreErrors: ErrorType{
    case DispatchError
}