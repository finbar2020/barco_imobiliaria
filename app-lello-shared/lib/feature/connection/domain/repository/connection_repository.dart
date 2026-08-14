part of shared_features;

abstract class ConnectionRepository {
  Future<Try<bool>> healthCheck();
}
