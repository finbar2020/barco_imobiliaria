part of shared_features;

class ExpiredSessionRepositoryImpl extends ExpiredSessionRepository {
  ExpiredSessionLocalDataSource localDataSource;

  ExpiredSessionRepositoryImpl({required this.localDataSource});

  @override
  Future<Try<Nothing>> clear() async {
    try {
      localDataSource.clear();
      return Success(Nothing());
    } catch (e) {
      return Rejection<Nothing>(UnknownFailure(e));
    }
  }
}
