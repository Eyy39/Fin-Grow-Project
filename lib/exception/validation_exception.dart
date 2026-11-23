class ValidationException implements Exception {
  final String message;

  ValidationException(this.message);

  // Display error message
  @override
  String toString() {
    return 'ValidationException: $message';
  }
}
