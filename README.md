Ignore warnings: [Flutter FFI Example](https://codelabs.developers.google.com/codelabs/flutter-ffigen#4)
```shell
dart run ffigen --config ffigen.yaml
```

TODO:
- Remove static crap
- create classes for enums
- utis for string pointer conversion and the like

StateMachine necessary or does FDB return appropriate error messages?
  - APIVersion must be called first
  - Setting network options must be called before calling SetupNetwork().
  - Calling runNetwork() must be called after SetupNetwork().
