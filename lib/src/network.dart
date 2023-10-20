import 'dart:ffi';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'dart:async' as async;

import '../foundationdb.dart';

bool _isNetworkStarted = false;
final ReceivePort _receivePort = ReceivePort();

void runNetwork() {
  handleError(fdbc.fdb_run_network());
}

/// /
/// /* Parameter: Option takes no parameter
// 49
void setBuggifyDisable() {
  _setOption(49);
}

/// /
/// /* Parameter: Option takes no parameter
// 48
void setBuggifyEnable() {
  _setOption(48);
}

/// Set the probability of a BUGGIFY section being active for the current execution.  Only applies to code paths first traversed AFTER this option is changed. */
/// /* Parameter: (Int) probability expressed as a percentage between 0 and 100
// 50
void setBuggifySectionActivatedProbability(int percentage) {
  _setIntOption(50, percentage);
}

/// Set the probability of an active BUGGIFY section being fired */
/// /* Parameter: (Int) probability expressed as a percentage between 0 and 100
// 51
void setBuggifySectionFiredProbability(int percentage) {
  _setIntOption(51, percentage);
}

/// If set, callbacks from external client libraries can be called from threads created by the FoundationDB client library. Otherwise, callbacks will be called from either the thread used to add the callback or the network thread. Setting this option can improve performance when connected using an external client, but may not be safe to use in all environments. Must be set before setting up the network. WARNING: This feature is considered experimental at this time. */
/// /* Parameter: Option takes no parameter
// 61
void setCallbacksOnExternalThreads() {
  _setOption(61);
}

/// Disable client buggify */
/// /* Parameter: Option takes no parameter
// 81
void setClientBuggifyDisable() {
  _setOption(81);
}

/// Enable client buggify - will make requests randomly fail (intended for client testing) */
/// /* Parameter: Option takes no parameter
// 80
void setClientBuggifyEnable() {
  _setOption(80);
}

/// Set the probability of a CLIENT_BUGGIFY section being active for the current execution. */
/// /* Parameter: (Int) probability expressed as a percentage between 0 and 100
// 82
void setClientBuggifySectionActivatedProbability(int percentage) {
  _setIntOption(82, percentage);
}

/// Set the probability of an active CLIENT_BUGGIFY section being fired. A section will only fire if it was activated */
/// /* Parameter: (Int) probability expressed as a percentage between 0 and 100
// 83
void setClientBuggifySectionFiredProbability(int percentage) {
  _setIntOption(83, percentage);
}

/// Spawns multiple worker threads for each version of the client that is loaded.  Setting this to a number greater than one implies disable_local_client. */
/// /* Parameter: (Int) Number of client threads to be spawned.  Each cluster will be serviced by a single client thread.
// 65
void setClientThreadsPerVersion(int numClientThreads) {
  _setIntOption(65, numClientThreads);
}

/// Sets the directory for storing temporary files created by FDB client, such as temporary copies of client libraries. Defaults to /tmp */
/// /* Parameter: (String) Client directory for temporary files.
// 91
void setClientTmpDir(String clientTmpDir) {
  _setStringOption(91, clientTmpDir);
}

/// Prevents the multi-version client API from being disabled, even if no external clients are configured. This option is required to use GRV caching. */
/// /* Parameter: Option takes no parameter
// 72
void setDisableClientBypass() {
  _setOption(72);
}

/// Disables logging of client statistics, such as sampled transaction activity. */
/// /* Parameter: Option takes no parameter
// 70
void setDisableClientStatisticsLogging() {
  _setOption(70);
}

/// Prevents connections through the local client, allowing only connections through externally loaded client libraries. */
/// /* Parameter: Option takes no parameter
// 64
void setDisableLocalClient() {
  _setOption(64);
}

/// Disables the multi-version client API and instead uses the local client directly. Must be set before setting up the network. */
/// /* Parameter: Option takes no parameter
// 60
void setDisableMultiVersionClientApi() {
  _setOption(60);
}

/// Set a tracer to run on the client. Should be set to the same value as the tracer set on the server. */
/// /* Parameter: (String) Distributed tracer type. Choose from none, log_file, or network_lossy
// 90
void setDistributedClientTracer(String tracerType) {
  _setStringOption(90, tracerType);
}

/// Enables debugging feature to perform run loop profiling. Requires trace logging to be enabled. WARNING: this feature is not recommended for use in production. */
/// /* Parameter: Option takes no parameter
// 71
void setEnableRunLoopProfiling() {
  _setOption(71);
}

/// Searches the specified path for dynamic libraries and adds them to the list of client libraries for use by the multi-version client API. Must be set before setting up the network. */
/// /* Parameter: (String) path to directory containing client libraries
// 63
void setExternalClientDirectory(String pathToClientLibDir) {
  _setStringOption(63, pathToClientLibDir);
}

/// Adds an external client library for use by the multi-version client API. Must be set before setting up the network. */
/// /* Parameter: (String) path to client library
// 62
void setExternalClientLibrary(String pathToClientLib) {
  _setStringOption(62, pathToClientLib);
}

/// Fail with an error if there is no client matching the server version the client is connecting to */
/// /* Parameter: Option takes no parameter
// 69
void setFailIncompatibleClient() {
  _setOption(69);
}

/// Adds an external client library to be used with a future version protocol. This option can be used testing purposes only! */
/// /* Parameter: (String) path to client library
// 66
void setFutureVersionClientLibrary(String pathToClientLib) {
  _setStringOption(66, pathToClientLib);
}

/// Ignore the failure to initialize some of the external clients */
/// /* Parameter: Option takes no parameter
// 68
void setIgnoreExternalClientFailures() {
  _setOption(68);
}

/// Set internal tuning or debugging knobs */
/// /* Parameter: (String) knob_name=knob_value
// 40
void setKnob(String knobNameValue) {
  _setStringOption(40, knobNameValue);
}

/// Retain temporary external client library copies that are created for enabling multi-threading. */
/// /* Parameter: Option takes no parameter
// 67
void setRetainClientLibraryCopies() {
  _setOption(67);
}

/// Set the ca bundle */
/// /* Parameter: (Bytes) ca bundle
// 52
void setTlsCaBytes(String caBundle) {
  _setStringOption(52, caBundle);
}

/// Set the file from which to load the certificate authority bundle */
/// /* Parameter: (String) file path
// 53
void setTlsCaPath(String tlsCaPath) {
  _setStringOption(53, tlsCaPath);
}

/// Set the certificate chain */
/// /* Parameter: (Bytes) certificates
// 42
void setTlsCertBytes(String certificates) {
  _setStringOption(42, certificates);
}

/// Set the file from which to load the certificate chain */
/// /* Parameter: (String) file path
// 43
void setTlsCertPath(String tlsCertPath) {
  _setStringOption(43, tlsCertPath);
}

/// Set the private key corresponding to your own certificate */
/// /* Parameter: (Bytes) key
// 45
void setTlsKeyBytes(String key) {
  _setStringOption(45, key);
}

/// Set the file from which to load the private key corresponding to your own certificate */
/// /* Parameter: (String) file path
// 46
void setTlsKeyPath(String tlsKeyPath) {
  _setStringOption(46, tlsKeyPath);
}

/// Set the passphrase for encrypted private key. Password should be set before setting the key for the password to be used. */
/// /* Parameter: (String) key passphrase
// 54
void setTlsPassword(String tlsPassword) {
  _setStringOption(54, tlsPassword);
}

/// Set the peer certificate field verification criteria */
/// /* Parameter: (Bytes) verification pattern
// 47
void setTlsVerifyPeers(String verificationPattern) {
  _setStringOption(47, verificationPattern);
}

/// Select clock source for trace files. now (the default) or realtime are supported. */
/// /* Parameter: (String) Trace clock source
// 35
void setTraceClockSource(String traceClockSource) {
  _setStringOption(35, traceClockSource);
}

/// Enables trace output to a file in a directory of the clients choosing */
/// /* Parameter: (String) path to output directory (or NULL for current working directory)
// 30
void setTraceEnable(String outputDirectory) {
  _setStringOption(30, outputDirectory);
}

/// Once provided, this string will be used to replace the port/PID in the log file names. */
/// /* Parameter: (String) The identifier that will be part of all trace file names
// 36
void setTraceFileIdentifier(String fileIdentifier) {
  _setStringOption(36, fileIdentifier);
}

/// Select the format of the log files. xml (the default) and json are supported. */
/// /* Parameter: (String) Format of trace files
// 34
void setTraceFormat(String traceFileFormat) {
  _setStringOption(34, traceFileFormat);
}

/// Initialize trace files on network setup, determine the local IP later. Otherwise tracing is initialized when opening the first database. */
/// /* Parameter: Option takes no parameter
// 38
void setTraceInitializeOnSetup() {
  _setOption(38);
}

/// Sets the 'LogGroup' attribute with the specified value for all events in the trace output files. The default log group is 'default'. */
/// /* Parameter: (String) value of the LogGroup attribute
// 33
void setTraceLogGroup(String logGroup) {
  _setStringOption(33, logGroup);
}

/// Sets the maximum size of all the trace output files put together. This value should be in the range ``[0, INT64_MAX]``. If the value is set to 0, there is no limit on the total size of the files. The default is a maximum size of 104,857,600 bytes. If the default roll size is used, this means that a maximum of 10 trace files will be written at a time. */
/// /* Parameter: (Int) max total size of trace files
// 32
void setTraceMaxLogsSize(int maxTotalSize) {
  _setIntOption(32, maxTotalSize);
}

/// Set file suffix for partially written log files. */
/// /* Parameter: (String) Append this suffix to partially written log files. When a log file is complete, it is renamed to remove the suffix. No separator is added between the file and the suffix. If you want to add a file extension, you should include the separator - e.g. '.tmp' instead of 'tmp' to add the 'tmp' extension.
// 39
void setTracePartialFileSuffix(String partialFileSuffix) {
  _setStringOption(39, partialFileSuffix);
}

/// Sets the maximum size in bytes of a single trace output file. This value should be in the range ``[0, INT64_MAX]``. If the value is set to 0, there is no limit on individual file size. The default is a maximum size of 10,485,760 bytes. */
/// /* Parameter: (Int) max size of a single trace output file
// 31
void setTraceRollSize(int maxSize) {
  _setIntOption(31, maxSize);
}

/// Use the same base trace file name for all client threads as it did before version 7.2. The current default behavior is to use distinct trace file names for client threads by including their version and thread index. */
/// /* Parameter: Option takes no parameter
// 37
void setTraceShareAmongClientThreads() {
  _setOption(37);
}

// Must be called after fdb_select_api_version() (and zero or more calls to fdb_network_set_option()) and before any other function in this API. fdb_setup_network() can only be called once.
void setupNetwork() {
  handleError(fdbc.fdb_setup_network());
}

async.Future<void> startNetwork() async {
  void isoStartNetwork(int _) {
    runNetwork();
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

void stopNetwork() {
  _receivePort.listen((Object? message) {
    if (message == null) {
      print('shutdown fdb');
      _receivePort.close();
    }
  });
  handleError(fdbc.fdb_stop_network());
}

void _setIntOption(int networkOption, int optionValue) {
  final optionValueC = calloc<Int64>().cast<Uint8>();
  try {
    handleError(fdbc.fdb_network_set_option(
      networkOption,
      optionValueC,
      8,
    ));
  } finally {
    calloc.free(optionValueC);
  }
}

void _setOption(int networkOption) {
  handleError(fdbc.fdb_network_set_option(
    networkOption,
    nullptr,
    0,
  ));
}

void _setStringOption(int networkOption, String optionValue) {
  final optionValueC = optionValue.toNativeUtf8().cast<Uint8>();
  try {
    handleError(fdbc.fdb_network_set_option(
      networkOption,
      optionValueC,
      optionValue.length,
    ));
  } finally {
    calloc.free(optionValueC);
  }
}
