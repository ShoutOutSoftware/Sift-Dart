class SiftException implements Exception {
  final String errorMessage;

  SiftException(this.errorMessage);

  @override
  String toString() {
    return errorMessage;
  }
}
