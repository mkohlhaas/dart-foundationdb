class Network {
  // Must be called after fdb_select_api_version() (and zero or more calls to fdb_network_set_option()) and before any other function in this API. fdb_setup_network() can only be called once.
  // is this automatically done by openDatabase()
  static setupNetwork() {}

  /// Deprecated */
  /// /* Parameter: (String) IP:PORT
  // 10
  static setLocalAddress() {}

  /// Deprecated */
  /// /* Parameter: (String) path to cluster file
  // 20
  static setClusterFile() {}

  /// Enables trace output to a file in a directory of the clients choosing */
  /// /* Parameter: (String) path to output directory (or NULL for current working directory)
  // 30
  static setTraceEnable() {}

  /// Sets the maximum size in bytes of a single trace output file. This value should be in the range ``[0, INT64_MAX]``. If the value is set to 0, there is no limit on individual file size. The default is a maximum size of 10,485,760 bytes. */
  /// /* Parameter: (Int) max size of a single trace output file
  // 31
  static setTraceRollSize() {}

  /// Sets the maximum size of all the trace output files put together. This value should be in the range ``[0, INT64_MAX]``. If the value is set to 0, there is no limit on the total size of the files. The default is a maximum size of 104,857,600 bytes. If the default roll size is used, this means that a maximum of 10 trace files will be written at a time. */
  /// /* Parameter: (Int) max total size of trace files
  // 32
  static setTraceMaxLogsSize() {}

  /// Sets the 'LogGroup' attribute with the specified value for all events in the trace output files. The default log group is 'default'. */
  /// /* Parameter: (String) value of the LogGroup attribute
  // 33
  static setTraceLogGroup() {}

  /// Select the format of the log files. xml (the default) and json are supported. */
  /// /* Parameter: (String) Format of trace files
  // 34
  static setTraceFormat() {}

  /// Select clock source for trace files. now (the default) or realtime are supported. */
  /// /* Parameter: (String) Trace clock source
  // 35
  static setTraceClockSource() {}

  /// Once provided, this string will be used to replace the port/PID in the log file names. */
  /// /* Parameter: (String) The identifier that will be part of all trace file names
  // 36
  static setTraceFileIdentifier() {}

  /// Use the same base trace file name for all client threads as it did before version 7.2. The current default behavior is to use distinct trace file names for client threads by including their version and thread index. */
  /// /* Parameter: Option takes no parameter
  // 37
  static setTraceShareAmongClientThreads() {}

  /// Initialize trace files on network setup, determine the local IP later. Otherwise tracing is initialized when opening the first database. */
  /// /* Parameter: Option takes no parameter
  // 38
  static setTraceInitializeOnSetup() {}

  /// Set file suffix for partially written log files. */
  /// /* Parameter: (String) Append this suffix to partially written log files. When a log file is complete, it is renamed to remove the suffix. No separator is added between the file and the suffix. If you want to add a file extension, you should include the separator - e.g. '.tmp' instead of 'tmp' to add the 'tmp' extension.
  // 39
  static setTracePartialFileSuffix() {}

  /// Set internal tuning or debugging knobs */
  /// /* Parameter: (String) knob_name=knob_value
  // 40
  static setKnob() {}

  /// Deprecated */
  /// /* Parameter: (String) file path or linker-resolved name
  // 41
  static setTlsPlugin() {}

  /// Set the certificate chain */
  /// /* Parameter: (Bytes) certificates
  // 42
  static setTlsCertBytes() {}

  /// Set the file from which to load the certificate chain */
  /// /* Parameter: (String) file path
  // 43
  static setTlsCertPath() {}

  /// Set the private key corresponding to your own certificate */
  /// /* Parameter: (Bytes) key
  // 45
  static setTlsKeyBytes() {}

  /// Set the file from which to load the private key corresponding to your own certificate */
  /// /* Parameter: (String) file path
  // 46
  static setTlsKeyPath() {}

  /// Set the peer certificate field verification criteria */
  /// /* Parameter: (Bytes) verification pattern
  // 47
  static setTlsVerifyPeers() {}

  /// /
  /// /* Parameter: Option takes no parameter
  // 48
  static setBuggifyEnable() {}

  /// /
  /// /* Parameter: Option takes no parameter
  // 49
  static setBuggifyDisable() {}

  /// Set the probability of a BUGGIFY section being active for the current execution.  Only applies to code paths first traversed AFTER this option is changed. */
  /// /* Parameter: (Int) probability expressed as a percentage between 0 and 100
  // 50
  static setBuggifySectionActivatedProbability() {}

  /// Set the probability of an active BUGGIFY section being fired */
  /// /* Parameter: (Int) probability expressed as a percentage between 0 and 100
  // 51
  static setBuggifySectionFiredProbability() {}

  /// Set the ca bundle */
  /// /* Parameter: (Bytes) ca bundle
  // 52
  static setTlsCaBytes() {}

  /// Set the file from which to load the certificate authority bundle */
  /// /* Parameter: (String) file path
  // 53
  static setTlsCaPath() {}

  /// Set the passphrase for encrypted private key. Password should be set before setting the key for the password to be used. */
  /// /* Parameter: (String) key passphrase
  // 54
  static setTlsPassword() {}

  /// Disables the multi-version client API and instead uses the local client directly. Must be set before setting up the network. */
  /// /* Parameter: Option takes no parameter
  // 60
  static setDisableMultiVersionClientApi() {}

  /// If set, callbacks from external client libraries can be called from threads created by the FoundationDB client library. Otherwise, callbacks will be called from either the thread used to add the callback or the network thread. Setting this option can improve performance when connected using an external client, but may not be safe to use in all environments. Must be set before setting up the network. WARNING: This feature is considered experimental at this time. */
  /// /* Parameter: Option takes no parameter
  // 61
  static setCallbacksOnExternalThreads() {}

  /// Adds an external client library for use by the multi-version client API. Must be set before setting up the network. */
  /// /* Parameter: (String) path to client library
  // 62
  static setExternalClientLibrary() {}

  /// Searches the specified path for dynamic libraries and adds them to the list of client libraries for use by the multi-version client API. Must be set before setting up the network. */
  /// /* Parameter: (String) path to directory containing client libraries
  // 63
  static setExternalClientDirectory() {}

  /// Prevents connections through the local client, allowing only connections through externally loaded client libraries. */
  /// /* Parameter: Option takes no parameter
  // 64
  static setDisableLocalClient() {}

  /// Spawns multiple worker threads for each version of the client that is loaded.  Setting this to a number greater than one implies disable_local_client. */
  /// /* Parameter: (Int) Number of client threads to be spawned.  Each cluster will be serviced by a single client thread.
  // 65
  static setClientThreadsPerVersion() {}

  /// Adds an external client library to be used with a future version protocol. This option can be used testing purposes only! */
  /// /* Parameter: (String) path to client library
  // 66
  static setFutureVersionClientLibrary() {}

  /// Retain temporary external client library copies that are created for enabling multi-threading. */
  /// /* Parameter: Option takes no parameter
  // 67
  static setRetainClientLibraryCopies() {}

  /// Ignore the failure to initialize some of the external clients */
  /// /* Parameter: Option takes no parameter
  // 68
  static setIgnoreExternalClientFailures() {}

  /// Fail with an error if there is no client matching the server version the client is connecting to */
  /// /* Parameter: Option takes no parameter
  // 69
  static setFailIncompatibleClient() {}

  /// Disables logging of client statistics, such as sampled transaction activity. */
  /// /* Parameter: Option takes no parameter
  // 70
  static setDisableClientStatisticsLogging() {}

  /// Deprecated */
  /// /* Parameter: Option takes no parameter
  // 71
  static setEnableSlowTaskProfiling() {}

  /// Enables debugging feature to perform run loop profiling. Requires trace logging to be enabled. WARNING: this feature is not recommended for use in production. */
  /// /* Parameter: Option takes no parameter
  // 71
  static setEnableRunLoopProfiling() {}

  /// Prevents the multi-version client API from being disabled, even if no external clients are configured. This option is required to use GRV caching. */
  /// /* Parameter: Option takes no parameter
  // 72
  static setDisableClientBypass() {}

  /// Enable client buggify - will make requests randomly fail (intended for client testing) */
  /// /* Parameter: Option takes no parameter
  // 80
  static setClientBuggifyEnable() {}

  /// Disable client buggify */
  /// /* Parameter: Option takes no parameter
  // 81
  static setClientBuggifyDisable() {}

  /// Set the probability of a CLIENT_BUGGIFY section being active for the current execution. */
  /// /* Parameter: (Int) probability expressed as a percentage between 0 and 100
  // 82
  static setClientBuggifySectionActivatedProbability() {}

  /// Set the probability of an active CLIENT_BUGGIFY section being fired. A section will only fire if it was activated */
  /// /* Parameter: (Int) probability expressed as a percentage between 0 and 100
  // 83
  static setClientBuggifySectionFiredProbability() {}

  /// Set a tracer to run on the client. Should be set to the same value as the tracer set on the server. */
  /// /* Parameter: (String) Distributed tracer type. Choose from none, log_file, or network_lossy
  // 90
  static setDistributedClientTracer() {}

  /// Sets the directory for storing temporary files created by FDB client, such as temporary copies of client libraries. Defaults to /tmp */
  /// /* Parameter: (String) Client directory for temporary files.
  // 91
  static setClientTmpDir() {}

  /// This option is set automatically to communicate the list of supported clients to the active client. */
  /// /* Parameter: (String) [release version],[source version],[protocol version];... This is a hidden parameter and should not be used directly by applications.
  // 1000
  static setSupportedClientVersions() {}

  /// This option is set automatically on all clients loaded externally using the multi-version API. */
  /// /* Parameter: Option takes no parameter This is a hidden parameter and should not be used directly by applications.
  // 1001
  static setExternalClient() {}

  /// This option tells a child on a multiversion client what transport ID to use. */
  /// /* Parameter: (Int) Transport ID for the child connection This is a hidden parameter and should not be used directly by applications.
  // 1002
  static setExternalClientTransportId() {}
}
