part of shared_features;

abstract class AccessTokenRepository {
  Future<Try<AccessToken?>> select({String? role});
  Future<Try<AccessToken?>> save(AccessToken? token, {String? role});

  Future<Try<AccessToken?>> post(Credentials credentials);

  Future<Try<AccessToken?>> postInvite(Credentials credentials);

  Future<Try<AccessToken?>> switchRoles(String id);

  Future<Try<Nothing>> clear();

  Future<Try<String?>> deleteAccount();
}
