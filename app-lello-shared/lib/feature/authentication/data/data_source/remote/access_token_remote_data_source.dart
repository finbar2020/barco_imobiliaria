part of shared_features;

abstract class AccessTokenRemoteDataSource {
  Future<AccessTokenModel?> post(AccessTokenRequestModel model);
  Future<AccessTokenModel?> postInvite(AccessTokenRequestModel model);
  Future<AccessTokenModel?> switchRoles(String id);
  Future<String?> deleteAccount();
}
