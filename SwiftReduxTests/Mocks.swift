//
//  TestUtils.swift
//  SwiftRedux
//
//  Created by Aleksander Herforth Rendtslev on 05/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

import SwiftRedux

/**
 *  Application state
 */
struct AppState {
    var counter: Int!
    var countries:[String]!
    var textField: TextFieldState!
}

/**
 *  Nested textField state.
 *  Application state can effectively be compartementalized this way.
 */
struct TextFieldState {
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
func applicationReducer(state: AppState? = nil, action: Action) -> AppState {
    return AppState(
        counter: counterReducer(state?.counter, action: action),
        countries: countryReducer(state?.countries, action: action),
        textField: textFieldReducer(state?.textField, action: action))
}

/**
 Example of a simple counter reducer. This state takes a simple integer value and returns it in an incremented state - for the IncrementAction
 This could also have a decrementAction.

 - parameter previousState: Int
 - parameter action:        ActionType

 - returns: Will return nextState - Int
 */
func counterReducer(previousState: Int?, action: Action) -> Int{

    // Declare the type of the state
    let state = previousState ?? 0

    switch action {
    case let action as IncrementAction:
        return state + action.rawPayload
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
func countryReducer(previousState: [String]?,  action: Action) -> [String]{

    let state = previousState ?? [String]()

    switch action {
    case let action as PushAction:
        return state + [action.rawPayload.text]
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
func textFieldReducer(previousState: TextFieldState?, action: Action) -> TextFieldState {

    switch action {
    case let action as UpdateTextFieldAction:
        return TextFieldState(value: action.rawPayload.text)
    default:
        return previousState ?? TextFieldState()
    }
}


/**
 *  Simple updateTextFieldAction - with unique payload
 */
struct UpdateTextFieldAction: StandardAction {
    let meta: Any?
    let error: Bool
    let rawPayload: Payload

    init(payload: Payload?, meta: Any? = nil, error: Bool = false) {
        self.rawPayload = payload != nil ? payload! : Payload(text: "")
        self.meta = meta
        self.error = error
    }

    struct Payload {
        var text: String
    }
}

struct ReTravelAction: SimpleStandardAction {
    let meta: Any? = nil
    let error: Bool = false
    let rawPayload: Any? = nil
}


/**
 *  Simple IncrementAction. Since it doesn't utilize payload it has been set to 1
 */
struct IncrementAction: StandardAction {
    let meta: Any?
    let error: Bool
    let rawPayload: Int

    init(payload: Int? = nil, meta: Any? = nil, error: Bool = false) {
        self.rawPayload = payload ?? 1
        self.meta = meta
        self.error = error
    }
}

/**
 *  Push action
 */
struct PushAction: StandardAction {
    let meta: Any?
    let error: Bool
    let rawPayload: Payload

    init(payload: Payload?, meta: Any? = nil, error: Bool = false) {
        self.rawPayload = payload != nil ? payload! : Payload(text: "")
        self.meta = meta
        self.error = error
    }

    struct Payload{
        var text: String

        init(text: String) {
            self.text = text;
        }
    }
}

/**
 first middleware - it will add .first to the payload of any pushAction.

 - parameter store: store description

 - returns: return value description
 */
func firstPushMiddleware(next: Dispatch) -> Dispatch {
    return { action in
        if let pushAction = action as? PushAction {
            let newAction = PushAction(payload: PushAction.Payload(text: pushAction.rawPayload.text + ".first"))
            return next(newAction)
        }
        else {
            return next(action)
        }
    }
}

/**
 second middleware - it will add .secondary to the payload of any pushAction.

 - parameter store: store description

 - returns: return value description
 */
func secondaryPushMiddleware(next: Dispatch) -> Dispatch {
    return { action in
        if let pushAction = action as? PushAction {
            let newAction = PushAction(payload: PushAction.Payload(text: pushAction.rawPayload.text + ".secondary"))
            return next(newAction)
        }
        else {
            return next(action)
        }
    }
}

/**
 second middleware - it will add .secondary to the payload of any pushAction.

 - parameter store: store description

 - returns: return value description
 */
func reTravelMiddleware<Store where Store: StoreType>(store: () -> Store) -> Middleware {
    return { next in
        return { action in
            if (action is ReTravelAction) {
                store().dispatch(IncrementAction(payload: 10))
            }
            else if (action is IncrementAction) {
                return next(IncrementAction())
            }
            return next(action)
        }
    }
}
