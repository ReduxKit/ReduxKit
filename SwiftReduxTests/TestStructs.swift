//
//  TestUtils.swift
//  SwiftRedux
//
//  Created by Aleksander Herforth Rendtslev on 05/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//


struct BaseState: StateType{
    var counter: Int!
    var countries:[String]!
    var textField: TextFieldState!
}

struct TextFieldState: StateType{
    var value: String = "";
}



func ApplicationReducer(action: ActionType, state: BaseState?) -> BaseState{
        return BaseState(
            counter: state != nil ? CounterReducer(action, state: state!.counter) : CounterReducer(action),
            countries: state != nil ? CountryReducer(action, state: state!.countries): CountryReducer(action),
            textField: state != nil ? TextFieldReducer(action, state: state!.textField) : TextFieldReducer(action)
        )
}


func CounterReducer(action: ActionType, state: Int = 0) -> Int{
    // Declare the type of the state
    
    if(action is IncrementAction){
        var newState: Int = state;
        newState++
        return newState
    }else{
        return state;
    }
    
 
}

func CountryReducer( action: ActionType, state: [String] = [String]()) -> [String]{
    if let pushAction = action as? PushAction{
        var newState = state
        
        newState.append(pushAction.payload.text!)
        return newState
    }else{
        return state;
    }
}

func TextFieldReducer(action: ActionType, state: TextFieldState = TextFieldState()) -> TextFieldState{
    
    if let updateTextFieldAction = action as? UpdateTextFieldAction{
        let newState = TextFieldState(value: updateTextFieldAction.payload.text)
        
        return newState
    }else{
        return state
    }
}



struct UpdateTextFieldAction: ActionType, Payloadable{
    var payload: Payload
    
    init(text: String){
        payload = Payload(text: text)
    }
    
    struct Payload{
        var text: String
    }
}

struct IncrementAction: ActionType{
}


struct PushAction: ActionType, Payloadable{
    var payload: Payload
    
    init(text: String){
        payload = Payload(text: text)
    }
    
    
    struct Payload{
        var text: String?
        
        init(text: String){
            self.text = text;
        }
    }
}