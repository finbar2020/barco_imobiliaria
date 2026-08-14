part of shared_features;

abstract class AccessTokenLocalDataSource {
  Future<AccessTokenModel?> select({required String role});
  Future<AccessTokenModel?> save(AccessTokenModel? token,
      {required String role});
}
