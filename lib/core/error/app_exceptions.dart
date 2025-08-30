/// Base application exception
abstract class AppException implements Exception {
  final String message;
  final String? details;

  const AppException(this.message, {this.details});

  @override
  String toString() => "$runtimeType: $message ${details ?? ''}";
}

/// Thrown when network call fails
class NetworkException extends AppException {
  const NetworkException(super.message, {super.details});
}

/// Thrown when parsing / mapping fails
class ParsingException extends AppException {
  const ParsingException(super.message, {super.details});
}
