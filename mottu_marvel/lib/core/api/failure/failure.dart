class Failure {
  final String message;
  final StackTrace? stackTrace;
  final Exception? exception;

  Failure({
    required this.message,
    this.stackTrace,
    this.exception,
  });
}
