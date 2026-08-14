part of shared_features;

class ConnectionRepositoryImpl extends ConnectionRepository {
  final ConnectionRemoteDataSource remoteDataSource;

  ConnectionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Try<bool>> healthCheck() async {
    try {
      final bool result = await remoteDataSource.healthCheck();
      return Success(result);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }
}
