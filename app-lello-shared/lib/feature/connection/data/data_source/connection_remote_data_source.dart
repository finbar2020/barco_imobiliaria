part of shared_features;

abstract class ConnectionRemoteDataSource {
  Future<bool> healthCheck();
}
