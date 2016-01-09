//: [Previous](@previous)

import ReduxKit

// Mark: - Types for testing

// Mark: Actions

enum CountEnumAction: Action { case Increment }
struct IncrementCountStructAction: Action {}
class IncrementCountClassAction: Action {}


// Mark: State

protocol AppState {
    var count: Int { get }
    init(count: Int)
}

struct StructLetState: AppState {
    let count: Int
    init(count: Int) { self.count = count }
}

struct StructVarState: AppState {
    var count: Int
    init(count: Int) { self.count = count }
}

final class ClassLetState: AppState, CustomStringConvertible {
    let count: Int
    var description: String { return "ClassLetState(count: \(count))" }
    init(count: Int) { self.count = count }
}

final class ClassVarState: AppState, CustomStringConvertible {
    var count: Int
    var description: String { return "ClassVarState(count: \(count))" }
    init(count: Int) { self.count = count }
}

// Mark: generic reducer generator

func createReducer(type: AppState.Type) -> (state: AppState?, action: Action) -> AppState {
    return { state, action in
        return type.init(count: (state?.count ?? 0) + 1)
    }
}


// Mark: - Test

// Struct let
let storeStructLet = createStore(createReducer(StructLetState), state: nil)
storeStructLet.subscribe { print($0) }
storeStructLet.dispatch(CountEnumAction.Increment) // -> StructLetState(count: 2)
storeStructLet.dispatch(CountEnumAction.Increment) // -> StructLetState(count: 3)

// Struct var
let storeStructVar = createStore(createReducer(StructVarState), state: nil)
storeStructVar.subscribe { print($0) }
storeStructVar.dispatch(CountEnumAction.Increment) // -> StructVarState(count: 2)
var structVarState = storeStructVar.state as! StructVarState
structVarState.count += 1 // <- this doesn't affect the actual state because of value type copy-on-write
storeStructVar.dispatch(CountEnumAction.Increment) // -> StructVarState(count: 3)

// Class let
let storeClassLet = createStore(createReducer(ClassLetState), state: nil)
storeClassLet.subscribe { print($0) }
storeClassLet.dispatch(CountEnumAction.Increment) // -> ClassLetState(count: 2)
storeClassLet.dispatch(CountEnumAction.Increment) // -> ClassLetState(count: 3)

// Class var
let storeClassVar = createStore(createReducer(ClassVarState), state: nil)
storeClassVar.subscribe { print($0) }
storeClassVar.dispatch(CountEnumAction.Increment) // -> ClassVarState(count: 2)
var classVarState = storeClassVar.state as! ClassVarState
classVarState.count += 1 // <- Where as this is not good as the state is passed as a reference type
storeClassVar.dispatch(CountEnumAction.Increment) // -> ClassVarState(count: 4)
// Not good: the above should have been ClassVarState(count: 3), but because of the class type it can be unexpected

//: [Next](@next)
