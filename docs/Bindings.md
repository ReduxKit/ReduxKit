## Bindings

The ReduxKit Store is, at it's heart, a subscribable stream of states. You are likely already familiar with the concept from reactive frameworks. The two are so similar in fact that you will more than likely want to use ReduxKit with you favourite reactive framework.

It is very easy to create a createStore function that wraps existing reactive frameworks. ReduxKit already has bindings available for:

- [RxSwift](https://github.com/ReduxKit/ReduxKitRxSwift)
- [ReactiveCocoa](https://github.com/ReduxKit/ReduxKitReactiveCocoa)
- [ReactiveKit](https://github.com/ReduxKit/ReduxKitReactiveKit)
- [SwiftBond](https://github.com/ReduxKit/ReduxKitBond)
