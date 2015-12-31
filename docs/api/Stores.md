ReduxKit stores are constructed with a `createStore` function that returns the `Store`.

The store creation functions can be easily replaced if needed or wrapped with a `StoreEnhancer`.

Using a completely generic store creator means you are able to construct state out of any object in swift.