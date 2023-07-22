abstract class APIError implements Exception {
  final String message;
  APIError(this.message);

  @override
  String toString() {
    return "${runtimeType.toString()} error with message: $message";
  }
}

class ServerError extends APIError {
  ServerError() : super("");

  @override
  String toString() {
    return "${runtimeType.toString()} error";
  }
}

class BadRequest extends APIError {
  BadRequest(String message) : super(message);
}

class AuthorizationError extends APIError {
  AuthorizationError(String message) : super(message);
}

class NotFound extends APIError {
  NotFound(String message) : super(message);
}
