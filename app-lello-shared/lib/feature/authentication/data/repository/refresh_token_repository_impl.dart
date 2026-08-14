part of shared_features;

class RefreshTokenRepositoryImpl extends RefreshTokenRepository {
  final AccessTokenLocalDataSource dataSource;
  final RefreshTokenRemoteDataSource remoteDataSource;

  RefreshTokenRepositoryImpl(
      {required this.remoteDataSource, required this.dataSource});

  @override
  Future<Try<AccessToken?>> select({String? role}) async {
    try {
      final model = await this.dataSource.select(role: role ?? "");
      return Success(model?.toEntity());
    } catch (ex) {
      return Rejection<AccessToken>(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<AccessToken?>> save(AccessToken? token, {String? role}) async {
    try {
      final model = AccessTokenModel.fromEntity(token);
      final result = await this.dataSource.save(model, role: role ?? "");
      return Success(result?.toEntity());
    } catch (ex) {
      return Rejection<AccessToken>(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<AccessToken?>> refreshToken() async {
    try {
      final curentToken = await this.dataSource.select(role: "");

      if (curentToken?.accessToken == null)
        return Rejection<AccessToken>(UnknownFailure("No token found"));

      if (curentToken?.refreshToken == null)
        return Rejection<AccessToken>(
            BadRefreshTokenFailure("no_refresh_token", null));

      final request = RefreshTokenRequestModel(
          token: curentToken!.accessToken!,
          refreshToken: curentToken.refreshToken!);

      final result = await this.remoteDataSource.refreshToken(request);
      return Success(result?.toEntity());
    } on ApiFailure catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'id: $id',
      );
      return Rejection(_mapApiFailure(e));
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'id: $id',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<Nothing>> clear() async {
    try {
      await dataSource.save(null, role: "");
      return Success(Nothing());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  Failure _mapApiFailure(ApiFailure err) {
    if (err.failure ==
            RefreshTokenRemoteDataSourceImpl.bad_refresh_token_failure ||
        err.status == HttpStatus.forbidden)
      return BadRefreshTokenFailure(
          err.title ?? err.detail ?? "bad_refresh_token_failure", err);
    return UnknownFailure(err);
  }
}
