
// An abstract class for all failures.
abstract class Failure {
  final String message;
  const Failure(this.message);
}

// Represents a failure from the server (API).
class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

// Represents a failure from local cache (e.g., SharedPreferences).
class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}