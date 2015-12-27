//: [Previous](@previous)

import ReduxKit

// Mark: - Setup

struct AppState {
    var count: Int!
}

struct CountAction: SimpleStandardAction {
    let meta: Any? = nil
    let error: Bool = false
    let rawPayload: Int = 1
}

func reducer(state: AppState? = nil, action: Action) -> AppState {
    switch action {
    case let action as CountAction:
        return AppState(count: (state?.count ?? 0) + action.rawPayload)
    default:
        return state ?? AppState(count: 0)
    }
}

let store = createStore(reducer, state: nil)

// MARK: - Test

var state1: AppState!
let disposable1 = store.subscribe { state1 = $0 }

var state2: AppState!
let disposable2 = store.subscribe { state2 = $0 }

let dump: () -> String = { _ in
    let countStore = store.state.count.description
    let countState1 = state1 == nil ? "nil" : state1.count.description
    let countState2 = state2 == nil ? "nil" : state2.count.description
    return "States: (\(countStore), \(countState1), \(countState2))"
}

let count: () -> () = { store.dispatch(CountAction()) }

let countAndDump: () -> String = { _ in
    count()
    return dump()
}

// MARK: - Test

dump() // -> States: (0, nil, nil)


countAndDump() // -> States: (1, 1, 1)


countAndDump() // -> States: (2, 2, 2)


disposable2.dispose()
countAndDump() // -> States: (3, 3, 2)


disposable1.dispose()
countAndDump() // -> States: (4, 3, 2)


store.subscribe { state1 = $0 }
dump() // -> States: (4, 3, 2)


countAndDump() // States: (5, 5, 2)



//: [Next](@next)
