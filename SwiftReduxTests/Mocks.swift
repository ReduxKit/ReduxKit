//
//  TestUtils.swift
//  SwiftRedux
//
//  Created by Aleksander Herforth Rendtslev on 05/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//



/**
*  Application state
*/
struct AppState: StateType{
    var counter: Int!
    var countries:[String]!
    var textField: TextFieldState!
}

/**
 *  Nested textField state. 
 *  Application state can effectively be compartementalized this way.
 */
struct TextFieldState: StateType{
    var value: String = "";
}



/**
 Total application reducer. This should create your base state and associate each individual reducer with its part of the state.
 Reducers can effectively be nested to avoid having to specify the whole chain on the top level.
 All reducers have been implemented with optional states. This is to simplify this reducer, so that it can be called without an initial AppState
 
 
 - parameter state:  AppState - will default to nil
 - parameter action: ActionType
 
 - returns: Will return BaseState
 */
func applicationReducer(state: AppState? = nil, action: ActionType) -> AppState{
    
    return AppState(
        counter: counterReducer(state?.counter, action: action),
        countries: countryReducer(state?.countries, action: action),
        textField: textFieldReducer(state?.textField, action: action)
    )
}

/**
 Example of a simple counter reducer. This state takes a simple integer value and returns it in an incremented state - for the IncrementAction
 This could also have a decrementAction.
 
 - parameter previousState: Int
 - parameter action:        ActionType
 
 - returns: Will return nextState - Int
 */
func counterReducer(previousState: Int?, action: ActionType) -> Int{
    
    // Declare the type of the state
    let defaultValue = 0
    var state = previousState ?? defaultValue
    
    
    switch action {
    case is Action<IncrementAction>:
        state++
        return state
    default:
        return state
    }
}


/**
 Example of an array based reducer. It will push any new values into a new array and return it.
 
 - parameter previousState: [String]?
 - parameter action:        ActiontYpe
 
 - returns: Will return nextState: [String]
 */
func countryReducer(previousState: [String]?,  action: ActionType) -> [String]{
    
    let defaultValue = [String]()
    var state = previousState ?? defaultValue
    
    switch action{
    case let action as Action<PushAction>:
        state.append(action.payload.text)
        return state
    default:
        return state
        
    }
}


/**
 Example of a more complex reducer. It takes a textFieldState as an argument and returns a new textFieldState
 
 - parameter previousState: TextFieldState?
 - parameter action:        ActionType
 
 - returns: Will return nextState: TextFieldState
 */
func textFieldReducer(previousState: TextFieldState?, action: ActionType) -> TextFieldState{
    
    let defaultValue = TextFieldState()
    var state = previousState ?? defaultValue
    
    
    
    switch action{
    case let action as Action<UpdateTextFieldAction>:
        state = TextFieldState(value: action.payload.text)
        return state
    default:
        return state
    }
    
    
}


/**
 *  Simple updateTextFieldAction - with unique payload
 */
struct UpdateTextFieldAction: Payloadable{
    typealias PayloadType = Payload
    static var defaultValue = Payload(text: "")
    
    struct Payload{
        var text: String
    }
}

/**
 *  Simple IncrementAction. Since it doesn't utilize payload it has been set to 1
 */
struct IncrementAction: Payloadable{
    typealias PayloadType = Int
    static var defaultValue = 1
}

/**
 *  Push action
 */
struct PushAction: Payloadable{
    typealias PayloadType = Payload
    static var defaultValue = Payload(text: "")
    
    struct Payload{
        var text: String
        
        init(text: String){
            self.text = text;
        }
    }
}

/**
 first middleware - it will add .first to the payload of any pushAction.
 
 - parameter store: <#store description#>
 
 - returns: <#return value description#>
 */
func firstPushMiddleware<T>(store: MiddlewareApi<T>) -> MiddlewareReturnFunction{
    return {(dispatch: DispatchFunction) in
        return{(action:ActionType) in
            if let pushAction = action as? Action<PushAction>{
                let newAction = Action<PushAction>(payload: PushAction.Payload(text: pushAction.payload.text + ".first"))
                
                let result = dispatch(action: newAction)
                return result
                
            }else{
                return action
            }

        }
    }
}

/**
 second middleware - it will add .secondary to the payload of any pushAction.
 
 - parameter store: store description
 
 - returns: return value description
 */
func secondaryPushMiddleware<T>(store: MiddlewareApi<T>) -> MiddlewareReturnFunction{
    return {(dispatch: DispatchFunction) in
        return{(action:ActionType) in
            if let pushAction = action as? Action<PushAction>{
                let newAction = Action<PushAction>(payload: PushAction.Payload(text: pushAction.payload.text + ".secondary"))
                
                let result = dispatch(action: newAction)
                return result
                
            }else{
                return action
            }

        }
    }
}