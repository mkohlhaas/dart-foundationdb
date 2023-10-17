Ignore warnings: [Flutter FFI Example](https://codelabs.developers.google.com/codelabs/flutter-ffigen#4)
```shell
dart run ffigen --config ffigen.yaml
```

StateMachine or does FDB return appropriate error messages?
  - APIVersion must be called first
  - Setting network options must be called before calling SetupNetwork().
  - Calling runNetwork() must be called after SetupNetwork().
  - ...

Singleton:
  - final fdbc = FDBC(DynamicLibrary.open('libfdb_c.so'));
  - from https://github.com/apple/foundationdb/blob/main/bindings/ruby/lib/fdbimpl.rb
    Use this package to find architecture: x86_64, ARM64, ...
    - https://pub.dev/packages/system_info2

      import 'dart:io' show Platform;
      var so = switch(Platform.operatingSystem) {
          case 'linux': 'libfdb_c.so';
          case 'macos': 'libfdb_c.dylib';
          case 'windows': 'fdb_c.dll';
        }


Classes:
  - FDB: use static functions: (see e.g. 'fdb.go'; "global" functions)
    - APIVersion()
    - OpenDatabase()
    - StartNetwork()
  - Database (database.go)
    - Close()
    - CreateTransaction()
    - Transact()
    - OpenTenant() (see Tenant class)
    - SetOptions:
      - see FDBTransactionOption
        - SetLocationCacheSize
        - SetMaxWatches
  - Tenant
    - Destroy()
    - CreateTransaction()
  - Transaction
    - Transact()
    - GetRange()
    - SetOptions:
      - SetLocalAddress()
      - SetClusterFile()
  - Network (generated.go)
    - SetupNetwork()
    - StartNetwork()
    - RunNetwork()
    - StopNetwork()
    - SetOptions:
      - see FDBNetworkOption
        - SetLocalAddress()
        - SetClusterFile()
  - FDBException
    - toString()
  - Future -> Dart Futures with [Completer](https://api.flutter.dev/flutter/dart-async/Completer-class.html)
    - BlockUntilReady()
    - IsReady()
  - Tuples
  - Directory
  - Subspace
