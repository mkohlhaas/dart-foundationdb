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

void setBuggifyDisable() {
  _setOption(49);
}

void setBuggifyEnable() {
  _setOption(48);
}

/// Set the probability of a BUGGIFY section being active for the current execution.
void setBuggifySectionActivatedProbability(int percentage) {
  _setIntOption(50, percentage);
}

/// Set the probability of an active BUGGIFY section being fired
void setBuggifySectionFiredProbability(int percentage) {
  _setIntOption(51, percentage);
}

/// If set, callbacks from external client libraries can be called from threads created by the FoundationDB client library. Otherwise, callbacks will be called from either the thread used to add the callback or the network thread. Setting this option can improve performance when connected using an external client, but may not be safe to use in all environments. Must be set before setting up the network. WARNING: This feature is considered experimental at this time.
void setCallbacksOnExternalThreads() {
  _setOption(61);
}

/// Disable client buggify
void setClientBuggifyDisable() {
  _setOption(81);
}

/// Enable client buggify - will make requests randomly fail (intended for client testing)
void setClientBuggifyEnable() {
  _setOption(80);
}

/// Set the probability of a CLIENT_BUGGIFY section being active for the current execution.
void setClientBuggifySectionActivatedProbability(int percentage) {
  _setIntOption(82, percentage);
}

/// Set the probability of an active CLIENT_BUGGIFY section being fired. A section will only fire if it was activated
void setClientBuggifySectionFiredProbability(int percentage) {
  _setIntOption(83, percentage);
}

/// Spawns multiple worker threads for each version of the client that is loaded.  Setting this to a number greater than one implies disable_local_client.
void setClientThreadsPerVersion(int numClientThreads) {
  _setIntOption(65, numClientThreads);
}

/// Sets the directory for storing temporary files created by FDB client, such as temporary copies of client libraries. Defaults to /tmp
void setClientTmpDir(String clientTmpDir) {
  _setStringOption(91, clientTmpDir);
}

/// Prevents the multi-version client API from being disabled, even if no external clients are configured. This option is required to use GRV caching.
void setDisableClientBypass() {
  _setOption(72);
}

/// Disables logging of client statistics, such as sampled transaction activity.
void setDisableClientStatisticsLogging() {
  _setOption(70);
}

/// Prevents connections through the local client, allowing only connections through externally loaded client libraries.
void setDisableLocalClient() {
  _setOption(64);
}

/// Disables the multi-version client API and instead uses the local client directly. Must be set before setting up the network.
void setDisableMultiVersionClientApi() {
  _setOption(60);
}

/// Set a tracer to run on the client. Should be set to the same value as the tracer set on the server.
void setDistributedClientTracer(String tracerType) {
  _setStringOption(90, tracerType);
}

/// Enables debugging feature to perform run loop profiling. Requires trace logging to be enabled. WARNING: this feature is not recommended for use in production.
void setEnableRunLoopProfiling() {
  _setOption(71);
}

/// Searches the specified path for dynamic libraries and adds them to the list of client libraries for use by the multi-version client API. Must be set before setting up the network.
void setExternalClientDirectory(String pathToClientLibDir) {
  _setStringOption(63, pathToClientLibDir);
}

/// Adds an external client library for use by the multi-version client API. Must be set before setting up the network.
void setExternalClientLibrary(String pathToClientLib) {
  _setStringOption(62, pathToClientLib);
}

/// Fail with an error if there is no client matching the server version the client is connecting to
void setFailIncompatibleClient() {
  _setOption(69);
}

/// Adds an external client library to be used with a future version protocol. This option can be used testing purposes only!
void setFutureVersionClientLibrary(String pathToClientLib) {
  _setStringOption(66, pathToClientLib);
}

/// Ignore the failure to initialize some of the external clients
void setIgnoreExternalClientFailures() {
  _setOption(68);
}

/// Set internal tuning or debugging knobs
void setKnob(String knobNameValue) {
  _setStringOption(40, knobNameValue);
}

/// Retain temporary external client library copies that are created for enabling multi-threading.
void setRetainClientLibraryCopies() {
  _setOption(67);
}

/// Set the ca bundle
void setTlsCaBytes(String caBundle) {
  _setStringOption(52, caBundle);
}

/// Set the file from which to load the certificate authority bundle
void setTlsCaPath(String tlsCaPath) {
  _setStringOption(53, tlsCaPath);
}

/// Set the certificate chain
void setTlsCertBytes(String certificates) {
  _setStringOption(42, certificates);
}

/// Set the file from which to load the certificate chain
void setTlsCertPath(String tlsCertPath) {
  _setStringOption(43, tlsCertPath);
}

/// Set the private key corresponding to your own certificate
void setTlsKeyBytes(String key) {
  _setStringOption(45, key);
}

/// Set the file from which to load the private key corresponding to your own certificate
void setTlsKeyPath(String tlsKeyPath) {
  _setStringOption(46, tlsKeyPath);
}

/// Set the passphrase for encrypted private key. Password should be set before setting the key for the password to be used.
void setTlsPassword(String tlsPassword) {
  _setStringOption(54, tlsPassword);
}

/// Set the peer certificate field verification criteria
void setTlsVerifyPeers(String verificationPattern) {
  _setStringOption(47, verificationPattern);
}

/// Select clock source for trace files. now (the default) or realtime are supported.
void setTraceClockSource(String traceClockSource) {
  _setStringOption(35, traceClockSource);
}

/// Enables trace output to a file in a directory of the clients choosing
void setTraceEnable(String outputDirectory) {
  _setStringOption(30, outputDirectory);
}

/// Once provided, this string will be used to replace the port/PID in the log file names.
void setTraceFileIdentifier(String fileIdentifier) {
  _setStringOption(36, fileIdentifier);
}

/// Select the format of the log files. xml (the default) and json are supported.
void setTraceFormat(String traceFileFormat) {
  _setStringOption(34, traceFileFormat);
}

/// Initialize trace files on network setup, determine the local IP later. Otherwise tracing is initialized when opening the first database.
void setTraceInitializeOnSetup() {
  _setOption(38);
}

/// Sets the 'LogGroup' attribute with the specified value for all events in the trace output files. The default log group is 'default'.
void setTraceLogGroup(String logGroup) {
  _setStringOption(33, logGroup);
}

/// Sets the maximum size of all the trace output files put together. This value should be in the range ``[0, INT64_MAX]``. If the value is set to 0, there is no limit on the total size of the files. The default is a maximum size of 104,857,600 bytes. If the default roll size is used, this means that a maximum of 10 trace files will be written at a time.
void setTraceMaxLogsSize(int maxTotalSize) {
  _setIntOption(32, maxTotalSize);
}

/// Set file suffix for partially written log files.
void setTracePartialFileSuffix(String partialFileSuffix) {
  _setStringOption(39, partialFileSuffix);
}

/// Sets the maximum size in bytes of a single trace output file. This value should be in the range ``[0, INT64_MAX]``. If the value is set to 0, there is no limit on individual file size. The default is a maximum size of 10,485,760 bytes.
void setTraceRollSize(int maxSize) {
  _setIntOption(31, maxSize);
}

/// Use the same base trace file name for all client threads as it did before version 7.2. The current default behavior is to use distinct trace file names for client threads by including their version and thread index.
void setTraceShareAmongClientThreads() {
  _setOption(37);
}

/// Must be called after ``fdb_select_api_version()`` (and zero or more calls to ``fdb_network_set_option()``) and before any other function in this API. ``fdb_setup_network()`` can only be called once.
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
    await Isolate.spawn<int>(
      isoStartNetwork,
      0,
      onExit: _receivePort.sendPort,
    );
  }
}

void stopNetwork() {
  _receivePort.listen((Object? message) {
    if (message == null) {
      _receivePort.close();
    }
  });
  handleError(fdbc.fdb_stop_network());
}

void _setIntOption(int option, int value) {
  final valueC = calloc<Int64>().cast<Uint8>();
  try {
    handleError(fdbc.fdb_network_set_option(
      option,
      valueC,
      sizeOf<Int64>(),
    ));
  } finally {
    calloc.free(valueC);
  }
}

void _setOption(int option) {
  handleError(fdbc.fdb_network_set_option(
    option,
    nullptr,
    0,
  ));
}

void _setStringOption(int option, String value) {
  final valueC = value.toNativeUtf8();
  try {
    handleError(fdbc.fdb_network_set_option(
      option,
      valueC.cast(),
      value.length,
    ));
  } finally {
    calloc.free(valueC);
  }
}
