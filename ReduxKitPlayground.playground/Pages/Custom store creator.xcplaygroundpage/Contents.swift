//: [Previous](@previous)

import ReduxKit

// ----------------------------------------------------------------------------
//
// MARK: - Setup

struct AppState {
    var count: Int!
}

struct CountAction: Action {
    let payload: Int
    init(_ payload: Int = 1) {
        self.payload = payload
    }
}

func reducer(state: AppState? = nil, action: Action) -> AppState {
    switch action {
    case let action as CountAction:
        return AppState(count: (state?.count ?? 0) + action.payload)
    default:
        return state ?? AppState(count: 0)
    }
}

// ----------------------------------------------------------------------------
//
// MARK: - Store creator


func createBasicStore<State>(reducer: (State?, Action) -> State, state: State?) -> Store<State> {

    typealias Subscriber = State -> ()

    var currentState = state ?? reducer(state, DefaultAction())
    var nextToken = 0
    var subscribers = [Int: Subscriber]()

    let dispatch: (Action) -> Action = { action in
        currentState = reducer(currentState, action)
        subscribers.map { $1(currentState) }
        return action
    }

    let disposable: (Int) -> ReduxDisposable = { token in
        SimpleReduxDisposable(
            disposed: { subscribers[token] != nil },
            dispose: { subscribers.removeValueForKey(token) })
    }

    let subscribe: (State -> ()) -> ReduxDisposable = { subscriber in
        let token = nextToken
        nextToken += 1
        subscribers[token] = subscriber
        return disposable(token)
    }

    return Store(dispatch: dispatch, subscribe: subscribe, getState: { currentState })
}


let store = createBasicStore(reducer, state: nil)



// ----------------------------------------------------------------------------
//
// MARK: - Test

let dump: () -> String = { "\(store.state)" }

let count: () -> () = { store.dispatch(CountAction()) }

let countAndDump: () -> String = { _ in
    count()
    return dump()
}

// ----------------------------------------------------------------------------

dump()         // -> AppState(count: 0)
countAndDump() // -> AppState(count: 1)
countAndDump() // -> AppState(count: 2)

//: [Next](@next)
