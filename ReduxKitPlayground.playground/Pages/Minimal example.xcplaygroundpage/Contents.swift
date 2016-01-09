import ReduxKit


// Mark: - Setup

struct AppState {
    var count: Int!
}

enum CountEnumAction: Action {
    case Increment
    case Decrement
    case Set(Int)
}

struct CountAction: SimpleStandardAction {
    let meta: Any? = nil
    let error: Bool = false
    let rawPayload: Int = 1
}

func reducer(previousState: AppState? = nil, action: Action) -> AppState {
    let state = previousState ?? AppState(count: 0)

    switch action {
    case let action as CountAction:
        return AppState(count: state.count + action.rawPayload)

    case CountEnumAction.Increment:
        return AppState(count: state.count + 1)

    case CountEnumAction.Decrement:
        return AppState(count: state.count - 1)

    case CountEnumAction.Set(let value):
        return AppState(count: value)

    default:
        return state
    }
}

let store = createStore(reducer, state: nil)


// Mark: - Test

store.dispatch(CountAction())
print(store.state) // -> AppState(count: 1)


store.dispatch(CountEnumAction.Increment)
print(store.state) // -> AppState(count: 2)


store.dispatch(CountEnumAction.Decrement)
print(store.state) // -> AppState(count: 1)


store.dispatch(CountEnumAction.Set(99))
print(store.state) // -> AppState(count: 99)
