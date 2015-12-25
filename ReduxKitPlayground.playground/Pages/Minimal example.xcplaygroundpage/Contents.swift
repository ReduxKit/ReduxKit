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


// Mark: - Test

store.dispatch(CountAction())
print(store.state) // -> AppState(count: 1)


store.dispatch(CountAction())
print(store.state) // -> AppState(count: 2)

