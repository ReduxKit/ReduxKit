# [![ReduxKit](https://cdn.rawgit.com/ReduxKit/ReduxKit/b3eb23d773f7c036d7567767884ed5cd50ff6b58/ReduxKit.svg)](https://github.com/ReduxKit/ReduxKit)

[![Build Status](https://img.shields.io/travis/ReduxKit/ReduxKit.svg)](https://travis-ci.org/ReduxKit/ReduxKit) [![Code coverage status](https://img.shields.io/codecov/c/github/ReduxKit/ReduxKit.svg)](http://codecov.io/github/ReduxKit/ReduxKit) [![Doc coverage](https://img.shields.io/cocoapods/metrics/doc-percent/ReduxKit.svg)](https://cocoapods.org/pods/ReduxKit)
[![Carthage Version](https://img.shields.io/github/tag/ReduxKit/ReduxKit.svg?label=carthage&color=4481C7)](https://github.com/Carthage/Carthage) [![Cocoapods Compatible](https://img.shields.io/cocoapods/v/ReduxKit.svg)](https://cocoapods.org/pods/ReduxKit) [![Platform](https://img.shields.io/cocoapods/p/ReduxKit.svg)](https://cocoapods.org/pods/ReduxKit) [![License MIT](https://img.shields.io/badge/license-MIT-4481C7.svg)](https://opensource.org/licenses/MIT)


## Cross promotion / pollination

> [\#13](https://github.com/ReduxKit/ReduxKit/issues/13): [@Ben-G](https://github.com/Ben-G) has done an awesome job of developing an independent, very idiomatic, swift implementation of Redux as [Swift-Flow](https://github.com/Swift-Flow/Swift-Flow).
>
> After a short discussion it's clear we all agree that collaboration and sharing of idea's will be beneficial to both projects. Go check it out. Feedback on both projects would be appreciated.

## Introduction

ReduxKit is a swift implementation of the JavaScript [Redux](http://rackt.github.io/redux) library by Dan Abramov and the React Community. ReduxKit stays as close as possible to Redux while bringing in Swift ways of doing things where appropriate.

A thorough walk through and description of the framework can be found at the official Redux repository: [Redux](http://rackt.github.io/redux).

It is currently implemented in a few swift apps and is frequently updated. Additions, middleware and help will be very much appreciated! So if you're trying it out and have any suggestions - feel free to post an issue and I'll be on it.

## Contents

- [Installation](http://reduxkit.github.io/ReduxKit/master/installation.html)
- [The Gist](http://reduxkit.github.io/ReduxKit/master/the-gist.html)
- [Types and generic State](http://reduxkit.github.io/ReduxKit/master/types-and-generic-state.html)
- [Bindings](http://reduxkit.github.io/ReduxKit/master/bindings.html)
- [Redux Compatibility](http://reduxkit.github.io/ReduxKit/master/redux-compatibility.html)
- [Flux Standard Actions](http://reduxkit.github.io/ReduxKit/master/flux-standard-actions.html)
- [Contributing](http://reduxkit.github.io/ReduxKit/master/contributing.html)
- [Progress](http://reduxkit.github.io/ReduxKit/master/progress.html)
- [License](http://reduxkit.github.io/ReduxKit/master/license.html)

### API

- [Stores](http://reduxkit.github.io/ReduxKit/master/Stores.html)
- [Disposables](http://reduxkit.github.io/ReduxKit/master/Disposables.html)
- [Actions](http://reduxkit.github.io/ReduxKit/master/Actions.html)
- [Middleware](http://reduxkit.github.io/ReduxKit/master/Middleware.html)
- [Utilities](http://reduxkit.github.io/ReduxKit/master/Utilities.html)

## Quick start

### [Installing with Carthage](https://github.com/Carthage/Carthage)

The easiest way to include ReduxKit is via Carthage:

**iOS 8.0 required**

Add ReduxKit to `Cartfile`

```
github "ReduxKit/ReduxKit" ~> 0.1
```

Run in terminal:

```bash
$ carthage update
```

### [Installing with CocoaPods](http://cocoapods.org)

Add ReduxKit to your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

pod 'ReduxKit', '~> 0.1'
```

Then, run the following command:

```bash
$ pod install
```


### The Gist

A more advanced Swift example of the original [gist](https://github.com/rackt/redux/blob/master/README.md#the-gist)

```swift
import ReduxKit

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
  * This is a simple reducer. It is a pure function that follows the syntax
  * (state, action) -> state.
  * It describes how an action transforms the previous state into the next state.
  *
  * Instead of using the actions.type property - as is done in the regular Redux framework
  * we use the power of Swifts static typing to deduce the action.
  */
func counterReducer(previousState: Int?, action: Action) -> Int {
    // Declare the reducers default value
    let defaultValue = 0
    var state = previousState ?? defaultValue

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
  * Create the applications reducer. While we could create a combineReducer function
  * we've currently chosen to allow reducers to be statically typed and accept
  * static states - instead of Any - which currently forces us to define the
  * application reducer as such. This could possibly be simplified with reflection.
  */
let applicationReducer = {(state: AppState? = nil, action: Action) -> AppState in

  return AppState(
    count: counterReducer(state?.count, action: action),
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

store.dispatch(DecrementAction())
// {counter: 1}

// Dispose of the subscriber after use.
disposable.dispose()

```

## License

[MIT](http://reduxkit.github.io/ReduxKit/license.html)


