import 'dart:io';
import 'dart:isolate';

import 'package:foundationdb/foundationdb.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

class Network {
  static bool _isNetworkStarted = false;
  static final ReceivePort _receivePort = ReceivePort();

  static Future<void> startNetwork() async {
    void isoStartNetwork(int _) {
      try {
        runNetwork();
      } catch (_) {
        rethrow;
      }
    }

    if (!_isNetworkStarted) {
      _isNetworkStarted = true;
      setupNetwork();
      Isolate isolate = await Isolate.spawn<int>(
        isoStartNetwork,
        0,
        onExit: _receivePort.sendPort,
      );
      print(isolate);
    }
  }

  // Must be called after fdb_select_api_version() (and zero or more calls to fdb_network_set_option()) and before any other function in this API. fdb_setup_network() can only be called once.
  static void setupNetwork() {
    try {
      handleError(fdbc.fdb_setup_network());
    } catch (_) {
      print('error in setupNetwork');
      rethrow;
    }
  }

  static void _setOption(int networkOption) {
    try {
      handleError(fdbc.fdb_network_set_option(
        networkOption,
        nullptr,
        0,
      ));
    } catch (_) {
      rethrow;
    }
  }

  static void _setIntOption(int networkOption, int optionValue) {
    final optionValueC = calloc<Int64>();
    try {
      handleError(fdbc.fdb_network_set_option(
        networkOption,
        optionValueC.cast(),
        64,
      ));
    } catch (_) {
      rethrow;
    } finally {
      calloc.free(optionValueC);
    }
  }

  static void _setStringOption(int networkOption, String optionValue) {
    final optionValueC = optionValue.toNativeUtf8();
    try {
      handleError(fdbc.fdb_network_set_option(
        networkOption,
        optionValueC.cast(),
        optionValue.length,
      ));
    } catch (_) {
      rethrow;
    } finally {
      calloc.free(optionValueC);
    }
  }

  static void stopNetwork() {
    try {
      _receivePort.listen((Object? message) {
        if (message == null) {
          print('shutdown fdb');
          _receivePort.close();
        }
      });
      handleError(fdbc.fdb_stop_network());
    } catch (_) {
      rethrow;
    }
  }

  static void runNetwork() {
    try {
      handleError(fdbc.fdb_run_network());
    } catch (_) {
      print('runNetwork');
      rethrow;
    }
  }

  /// Enables trace output to a file in a directory of the clients choosing */
  /// /* Parameter: (String) path to output directory (or NULL for current working directory)
  // 30
  static void setTraceEnable(String outputDirectory) {
    _setStringOption(30, outputDirectory);
  }

  /// Sets the maximum size in bytes of a single trace output file. This value should be in the range ``[0, INT64_MAX]``. If the value is set to 0, there is no limit on individual file size. The default is a maximum size of 10,485,760 bytes. */
  /// /* Parameter: (Int) max size of a single trace output file
  // 31
  static void setTraceRollSize(int maxSize) {
    _setIntOption(31, maxSize);
  }

  /// Sets the maximum size of all the trace output files put together. This value should be in the range ``[0, INT64_MAX]``. If the value is set to 0, there is no limit on the total size of the files. The default is a maximum size of 104,857,600 bytes. If the default roll size is used, this means that a maximum of 10 trace files will be written at a time. */
  /// /* Parameter: (Int) max total size of trace files
  // 32
  static void setTraceMaxLogsSize(int maxTotalSize) {
    _setIntOption(32, maxTotalSize);
  }

  /// Sets the 'LogGroup' attribute with the specified value for all events in the trace output files. The default log group is 'default'. */
  /// /* Parameter: (String) value of the LogGroup attribute
  // 33
  static void setTraceLogGroup(String logGroup) {
    _setStringOption(33, logGroup);
  }

  /// Select the format of the log files. xml (the default) and json are supported. */
  /// /* Parameter: (String) Format of trace files
  // 34
  static void setTraceFormat(String traceFileFormat) {
    _setStringOption(34, traceFileFormat);
  }

  /// Select clock source for trace files. now (the default) or realtime are supported. */
  /// /* Parameter: (String) Trace clock source
  // 35
  static void setTraceClockSource(String traceClockSource) {
    _setStringOption(35, traceClockSource);
  }

  /// Once provided, this string will be used to replace the port/PID in the log file names. */
  /// /* Parameter: (String) The identifier that will be part of all trace file names
  // 36
  static void setTraceFileIdentifier(String fileIdentifier) {
    _setStringOption(36, fileIdentifier);
  }

  /// Use the same base trace file name for all client threads as it did before version 7.2. The current default behavior is to use distinct trace file names for client threads by including their version and thread index. */
  /// /* Parameter: Option takes no parameter
  // 37
  static void setTraceShareAmongClientThreads() {
    _setOption(37);
  }

  /// Initialize trace files on network setup, determine the local IP later. Otherwise tracing is initialized when opening the first database. */
  /// /* Parameter: Option takes no parameter
  // 38
  static void setTraceInitializeOnSetup() {
    _setOption(38);
  }

  /// Set file suffix for partially written log files. */
  /// /* Parameter: (String) Append this suffix to partially written log files. When a log file is complete, it is renamed to remove the suffix. No separator is added between the file and the suffix. If you want to add a file extension, you should include the separator - e.g. '.tmp' instead of 'tmp' to add the 'tmp' extension.
  // 39
  static void setTracePartialFileSuffix(String partialFileSuffix) {
    _setStringOption(39, partialFileSuffix);
  }

  /// Set internal tuning or debugging knobs */
  /// /* Parameter: (String) knob_name=knob_value
  // 40
  static void setKnob(String knobNameValue) {
    _setStringOption(40, knobNameValue);
  }

  /// Set the certificate chain */
  /// /* Parameter: (Bytes) certificates
  // 42
  static void setTlsCertBytes(String certificates) {
    _setStringOption(42, certificates);
  }

  /// Set the file from which to load the certificate chain */
  /// /* Parameter: (String) file path
  // 43
  static void setTlsCertPath(String tlsCertPath) {
    _setStringOption(43, tlsCertPath);
  }

  /// Set the private key corresponding to your own certificate */
  /// /* Parameter: (Bytes) key
  // 45
  static void setTlsKeyBytes(String key) {
    _setStringOption(45, key);
  }

  /// Set the file from which to load the private key corresponding to your own certificate */
  /// /* Parameter: (String) file path
  // 46
  static void setTlsKeyPath(String tlsKeyPath) {
    _setStringOption(46, tlsKeyPath);
  }

  /// Set the peer certificate field verification criteria */
  /// /* Parameter: (Bytes) verification pattern
  // 47
  static void setTlsVerifyPeers(String verificationPattern) {
    _setStringOption(47, verificationPattern);
  }

  /// /
  /// /* Parameter: Option takes no parameter
  // 48
  static void setBuggifyEnable() {
    _setOption(48);
  }

  /// /
  /// /* Parameter: Option takes no parameter
  // 49
  static void setBuggifyDisable() {
    _setOption(49);
  }

  /// Set the probability of a BUGGIFY section being active for the current execution.  Only applies to code paths first traversed AFTER this option is changed. */
  /// /* Parameter: (Int) probability expressed as a percentage between 0 and 100
  // 50
  static void setBuggifySectionActivatedProbability(int percentage) {
    _setIntOption(50, percentage);
  }

  /// Set the probability of an active BUGGIFY section being fired */
  /// /* Parameter: (Int) probability expressed as a percentage between 0 and 100
  // 51
  static void setBuggifySectionFiredProbability(int percentage) {
    _setIntOption(51, percentage);
  }

  /// Set the ca bundle */
  /// /* Parameter: (Bytes) ca bundle
  // 52
  static void setTlsCaBytes(String caBundle) {
    _setStringOption(52, caBundle);
  }

  /// Set the file from which to load the certificate authority bundle */
  /// /* Parameter: (String) file path
  // 53
  static void setTlsCaPath(String tlsCaPath) {
    _setStringOption(53, tlsCaPath);
  }

  /// Set the passphrase for encrypted private key. Password should be set before setting the key for the password to be used. */
  /// /* Parameter: (String) key passphrase
  // 54
  static void setTlsPassword(String tlsPassword) {
    _setStringOption(54, tlsPassword);
  }

  /// Disables the multi-version client API and instead uses the local client directly. Must be set before setting up the network. */
  /// /* Parameter: Option takes no parameter
  // 60
  static void setDisableMultiVersionClientApi() {
    _setOption(60);
  }

  /// If set, callbacks from external client libraries can be called from threads created by the FoundationDB client library. Otherwise, callbacks will be called from either the thread used to add the callback or the network thread. Setting this option can improve performance when connected using an external client, but may not be safe to use in all environments. Must be set before setting up the network. WARNING: This feature is considered experimental at this time. */
  /// /* Parameter: Option takes no parameter
  // 61
  static void setCallbacksOnExternalThreads() {
    _setOption(61);
  }

  /// Adds an external client library for use by the multi-version client API. Must be set before setting up the network. */
  /// /* Parameter: (String) path to client library
  // 62
  static void setExternalClientLibrary(String pathToClientLib) {
    _setStringOption(62, pathToClientLib);
  }

  /// Searches the specified path for dynamic libraries and adds them to the list of client libraries for use by the multi-version client API. Must be set before setting up the network. */
  /// /* Parameter: (String) path to directory containing client libraries
  // 63
  static void setExternalClientDirectory(String pathToClientLibDir) {
    _setStringOption(63, pathToClientLibDir);
  }

  /// Prevents connections through the local client, allowing only connections through externally loaded client libraries. */
  /// /* Parameter: Option takes no parameter
  // 64
  static void setDisableLocalClient() {
    _setOption(64);
  }

  /// Spawns multiple worker threads for each version of the client that is loaded.  Setting this to a number greater than one implies disable_local_client. */
  /// /* Parameter: (Int) Number of client threads to be spawned.  Each cluster will be serviced by a single client thread.
  // 65
  static void setClientThreadsPerVersion(int numClientThreads) {
    _setIntOption(65, numClientThreads);
  }

  /// Adds an external client library to be used with a future version protocol. This option can be used testing purposes only! */
  /// /* Parameter: (String) path to client library
  // 66
  static void setFutureVersionClientLibrary(String pathToClientLib) {
    _setStringOption(66, pathToClientLib);
  }

  /// Retain temporary external client library copies that are created for enabling multi-threading. */
  /// /* Parameter: Option takes no parameter
  // 67
  static void setRetainClientLibraryCopies() {
    _setOption(67);
  }

  /// Ignore the failure to initialize some of the external clients */
  /// /* Parameter: Option takes no parameter
  // 68
  static void setIgnoreExternalClientFailures() {
    _setOption(68);
  }

  /// Fail with an error if there is no client matching the server version the client is connecting to */
  /// /* Parameter: Option takes no parameter
  // 69
  static void setFailIncompatibleClient() {
    _setOption(69);
  }

  /// Disables logging of client statistics, such as sampled transaction activity. */
  /// /* Parameter: Option takes no parameter
  // 70
  static void setDisableClientStatisticsLogging() {
    _setOption(70);
  }

  /// Enables debugging feature to perform run loop profiling. Requires trace logging to be enabled. WARNING: this feature is not recommended for use in production. */
  /// /* Parameter: Option takes no parameter
  // 71
  static void setEnableRunLoopProfiling() {
    _setOption(71);
  }

  /// Prevents the multi-version client API from being disabled, even if no external clients are configured. This option is required to use GRV caching. */
  /// /* Parameter: Option takes no parameter
  // 72
  static void setDisableClientBypass() {
    _setOption(72);
  }

  /// Enable client buggify - will make requests randomly fail (intended for client testing) */
  /// /* Parameter: Option takes no parameter
  // 80
  static void setClientBuggifyEnable() {
    _setOption(80);
  }

  /// Disable client buggify */
  /// /* Parameter: Option takes no parameter
  // 81
  static void setClientBuggifyDisable() {
    _setOption(81);
  }

  /// Set the probability of a CLIENT_BUGGIFY section being active for the current execution. */
  /// /* Parameter: (Int) probability expressed as a percentage between 0 and 100
  // 82
  static void setClientBuggifySectionActivatedProbability(int percentage) {
    _setIntOption(82, percentage);
  }

  /// Set the probability of an active CLIENT_BUGGIFY section being fired. A section will only fire if it was activated */
  /// /* Parameter: (Int) probability expressed as a percentage between 0 and 100
  // 83
  static void setClientBuggifySectionFiredProbability(int percentage) {
    _setIntOption(83, percentage);
  }

  /// Set a tracer to run on the client. Should be set to the same value as the tracer set on the server. */
  /// /* Parameter: (String) Distributed tracer type. Choose from none, log_file, or network_lossy
  // 90
  static void setDistributedClientTracer(String tracerType) {
    _setStringOption(90, tracerType);
  }

  /// Sets the directory for storing temporary files created by FDB client, such as temporary copies of client libraries. Defaults to /tmp */
  /// /* Parameter: (String) Client directory for temporary files.
  // 91
  static void setClientTmpDir(String clientTmpDir) {
    _setStringOption(91, clientTmpDir);
  }
}
