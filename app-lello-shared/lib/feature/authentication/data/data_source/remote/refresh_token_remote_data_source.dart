part of shared_features;

abstract class RefreshTokenRemoteDataSource {
  Future<AccessTokenModel?> refreshToken(RefreshTokenRequestModel model);
}
