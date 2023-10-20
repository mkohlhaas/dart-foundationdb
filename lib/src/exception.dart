class FDBException implements Exception {
  final String message;
  final int errorCode;

  FDBException(this.message, this.errorCode);

  @override
  String toString() => message;
}
