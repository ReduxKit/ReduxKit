//: [Previous](@previous)

import ReduxKit

// Mark: - Setup

/**
 * This is a simple standard action. The only requirement is that an action complies to
 * the Action protocol. The SimpleStandardAction contains a strongly typed rawPayload
 * property. The protocol automatically assigns the rawPayload to the Actions payload
 * property. This removes the necessity of type casting whenever working with actions in
 * a reducer.
 *
 * There's also the StandardAction protocol, that requires the struct to have an
 * initializer. This is required if the bindActionCreators helper is to be used.
 */
struct IncrementAction: SimpleStandardAction {
    let meta: Any? = nil
    let error: Bool = false
    let rawPayload: Int = 1
}

struct DecrementAction: SimpleStandardAction {
    let meta: Any? = nil
    let error: Bool = false
    let rawPayload: Int = 1
}

/**
 This is a simple reducer. It is a pure function that follows the syntax
 (state, action) -> state.
 It describes how an action transforms the previous state into the next state.

 Instead of using the actions.type property - as is done in the regular Redux framework
 we use the power of Swifts static typing to deduce the action.

 - parameter previousState: Int?
 - parameter action:        Action

 - returns: Int
 */
func counterReducer(previousState: Int?, action: Action) -> Int {
    let state = previousState ?? 0

    switch action {
    case let action as IncrementAction:
        return state + action.rawPayload
    case let action as DecrementAction:
        return state - action.rawPayload
    default:
        return state
    }
}

/**
 * The applications state. This should contain the state of the whole application.
 * When building larger applications, you can optionally assign complex structs to
 * properties on the AppState and handle them in the part of the application that
 * uses them.
 */
struct AppState {
    var count: Int!
}

/**
 Create the applications reducer. While we could create a combineReducer function
 we've currently chosen to allow reducers to be statically typed and accept
 static states - instead of Any - which currently forces us to define the
 application reducer as such. This could possibly be simplified with reflection.

 - parameter state:  AppState?
 - parameter action: Action

 - returns: AppState
 */
func applicationReducer(state: AppState? = nil, action: Action) -> AppState {
    return AppState(
        count: counterReducer(state?.count, action: action)
    )
}


// Create application store. The second parameter is an optional default state.
let store = createStore(applicationReducer, state: nil)

let disposable = store.subscribe { state in
    print(state)
}


// Mark: - Test

store.dispatch(IncrementAction())
// AppState(count: 1)

store.dispatch(IncrementAction())
// AppState(count: 2)

store.dispatch(DecrementAction())
// AppState(count: 1)

// Dispose of the subscriber after use.
disposable.dispose()



//: [Next](@next)
