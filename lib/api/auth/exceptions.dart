class InstanceNotFoundException implements Exception {
  final String message;
  const InstanceNotFoundException([this.message = "Instance not found"]);

  @override
  String toString() => message;
}

class UserNotFoundException implements Exception {
  final String message;
  const UserNotFoundException([this.message = "User not found"]);

  @override
  String toString() => message;
}

class InvalidCredentialsException implements Exception {
  final String message;
  const InvalidCredentialsException([this.message = "Invalid credentials"]);

  @override
  String toString() => message;
}

class UnknownAuthException implements Exception {
  final String message;
  const UnknownAuthException([this.message = "Unknown auth exception"]);

  @override
  String toString() => message;
}
