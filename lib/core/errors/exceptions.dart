abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([
    super.message = 'No internet connection. Please check your network',
  ]);
}

class ServerException extends AppException {
  const ServerException([
    super.message = 'Server error occurred. Please try again later',
  ]);
}

class UnknownException extends AppException {
  const UnknownException([
    super.message = 'Something went wrong. Please try again',
  ]);
}
