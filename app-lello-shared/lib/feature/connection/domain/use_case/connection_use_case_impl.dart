part of shared_features;

class ConnectionUseCaseImpl extends ConnectionUseCase {
  final ConnectionRepository repository;

  ConnectionUseCaseImpl({required this.repository});

  @override
  Future<Try<bool>> call(ConnectionParams params) async {
    return await repository.healthCheck();
  }
}
