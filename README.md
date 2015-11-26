# [reduxSwift](http://rackt.github.io/redux)

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Intro
reduxSWift is a swift implementation of rackt/redux by Dan Abramov and the React Community.
I am currently implementing this in a few swift apps so it will be frequently updated. Additions, middlewares and help will be very much appreciated!
A thorough walkthrough and description of the framework can be found at the official Redux repostory: [Redux](http://rackt.github.io/redux)


## Installation

### [Carthage](https://github.com/Carthage/Carthage)
The easiest way to include reduxSwift is via Carthage:

** Xcode 8.0 required **

Add this to `Cartfile`
```
github "Aleksion/reduxSwift"
```

Run in terminal:
```
$ carthage update
```

## Usage

``` swift
import SwiftRedux

/**
  * This is a simple standard action. The only requirement is that an action complies to
  * the Action protocol. The SimpleStandardAction containts a strongly typed rawPayload
  * property. The protocol automatically assigns the rawPayload to the Actions payload
  * property. This removes the necessity of type casting whenever working with actions in * a reducer.
  *
  * There's also the StandardAction protocol, that requires the struc to have an
  * initializer. This is required if the bindActionCreators helper is to be used.
  */
struct IncrementAction: SimpleStandardAction{
    let meta: Any? = nil
    let error: Bool = false
    let rawPayload: Int = 1
}

/**
  * This is a simple reducer. It is a pure function that follows the syntax
  * (state, action) -> state.
  * It describes how an action transforms the previous state into the next state.
  *
  * Instead of using the actions.type property - as is done in the regular Redux framework
  * we use the power of Swifts static typing to deduce the action.  
  */
func counterReducer(previousState: Int?, action: Action) -> Int{
    // Declare the reducers default value
    let defaultValue = 0
    var state = previousState ?? defaultValue

    switch action {
        case let action as IncrementAction:
            state = state + action.rawPayload
            return state
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
struct AppState: State{
  var count: Int!
}

/**
  * Create the applications reducer. While we could create a combineReducer function
  * we've currently chosen to allow reducers to be statically typed and accept
  * static states - instead of Any - which currently forces us to define the
  * application reducer as such. This could possibly be simplified with reflection.
  */
let applicationReducer = {(state: State? = nil, action: Action) -> State in

  // Optionally throw error if the given state isn't an AppState
  let appState = state as! AppState?

  return
    AppState(
            count: counterReducer(appState?.count, action: action),
    )
}

// Create application store. The second parameter is an optional default state.
let store = createStore(applicationReducer, nil)

let disposable = store.subscribe{ state in
  print(state)
}


store.dispatch(IncrementAction())
// {counter: 1}

store.dispatch(IncrementAction())
// {counter: 2}

store.dispatch(IncrementAction())
// {counter: 3}

// Dispose of the subscriber after use.
disposable.dispose()

```

## Available Middlewares
+ [reduxSwift-Rx](https://github.com/Aleksion/reduxSwift-rx)
  \- RxSwift utilities for ReduxSwift


## Input
I am hoping to get a solid influx of middlewares up and running for Swift-Redux so we can change the way we do iOS development in the future. I am therefor welcoming pull requests, feature requests and suggestions. I want this library to be the best it can be and I can only do that with the help of the rest of you.


### License

MIT
