
//
//  StoreTYpe.swift
//  SwiftRedux
//
//  Created by Aleksander Herforth Rendtslev on 03/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//



protocol StoreType{
    func Dispatch(action: ActionType)
}

struct Store<T where T:StateType>: StoreType{
    
    var reducer: (T, ActionType) -> T
    var state: T
    
    init(reducer: (T, ActionType) -> T, initialState: T){
        self.reducer = reducer
        state = initialState
    }
    
    
    func Dispatch(action: ActionType){
        
    }
}