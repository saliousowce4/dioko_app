
// Thrown when an error occurs during an API call.
class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

// Thrown when an error occurs during a local cache operation.
class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}