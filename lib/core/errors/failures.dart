abstract class Failure {
  final String message;

  const Failure({required this.message});
}

/// A failure representing a generic server error (e.g. 500, 404).
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

/// A failure representing a caching issue (e.g. no local data available).
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// A failure representing a lack of internet connectivity.
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}
