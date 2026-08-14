part of shared_features;

abstract class RefreshTokenRepository {
  Future<Try<AccessToken?>> select({String? role});
  Future<Try<AccessToken?>> save(AccessToken? token, {String? role});
  Future<Try<AccessToken?>> refreshToken();
  Future<Try<Nothing>> clear();
}
