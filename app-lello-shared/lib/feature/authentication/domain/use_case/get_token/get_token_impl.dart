part of shared_features;

class GetTokenImpl extends GetToken {
  final AccessTokenRepository repository;
  GetTokenImpl({required this.repository});

  @override
  Future<Try<AccessToken?>> call(GetTokenParams? params) async {
    return repository.select(role: params?.role);
  }
}
