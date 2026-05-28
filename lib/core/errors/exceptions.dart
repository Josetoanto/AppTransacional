class AppException implements Exception {
  AppException(this.message);

  final String message;

  @override
  String toString() => 'AppException: $message';
}

class NetworkException extends AppException {
  NetworkException(super.message);
}

class AuthException extends AppException {
  AuthException(super.message);
}

class ValidationException extends AppException {
  ValidationException(super.message);
}

class UnauthorizedException extends AppException {
  UnauthorizedException(super.message);
}

class NotFoundException extends AppException {
  NotFoundException(super.message);
}

class ServerException extends AppException {
  ServerException(super.message);
}
