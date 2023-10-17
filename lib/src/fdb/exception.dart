class Exception {
  final String message;

  Exception(this.message);

  static Exception loadError(int errorCode) {
    return Exception("TODO");
  }

  @override
  String toString() => message;
}
