abstract class APIError implements Exception {
  final String message;
  APIError(this.message);
}

class ServerError extends APIError {
  ServerError() : super("");
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
