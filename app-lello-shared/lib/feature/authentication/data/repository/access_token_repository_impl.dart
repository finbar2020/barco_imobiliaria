part of shared_features;

class AccessTokenRepositoryImpl extends AccessTokenRepository {
  final AccessTokenLocalDataSource dataSource;
  final AccessTokenRemoteDataSource remoteDataSource;

  AccessTokenRepositoryImpl(
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
  Future<Try<AccessToken?>> post(Credentials credentials) async {
    try {
      final request = AccessTokenRequestModel(
          username: credentials.username.replaceAll(new RegExp(r'[^0-9]'), ''),
          password: credentials.password);
      final result = await this.remoteDataSource.post(request);
      return Success(result?.toEntity());
    } on ApiFailure catch (e, stacktrace) {
      var faliure = _mapApiFailure(e);
      if (faliure is UnknownFailure) {
        FirebaseCrashlytics.instance.recordError(
          e,
          stacktrace,
          reason: 'idCpf: ${_cpfId(credentials.username)}',
        );
      }
      return Rejection(faliure);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'idCpf: ${_cpfId(credentials.username)}',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<AccessToken?>> postInvite(Credentials credentials) async {
    try {
      final request = AccessTokenRequestModel(
          username: credentials.username, password: credentials.password);
      final result = await this.remoteDataSource.postInvite(request);
      return Success(result?.toEntity());
    } on ApiFailure catch (e) {
      var faliure = _mapApiFailure(e);
      if (faliure is UnknownFailure) {
        // FirebaseCrashlytics.instance.recordError(
        //   e,
        //   stacktrace,
        //   reason: 'idCpf: ${credentials.username.substring(0, 5)}',
        // );
      }
      return Rejection(faliure);
    } catch (e) {
      // FirebaseCrashlytics.instance.recordError(
      //   e,
      //   stacktrace,
      //   reason: 'idCpf: ${credentials.username.substring(0, 5)}',
      // );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<AccessToken?>> switchRoles(String id) async {
    try {
      final result = await this.remoteDataSource.switchRoles(id);
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

  /// Prefixo do usuário (cpf) usado apenas para identificar o erro no
  /// Crashlytics. Tolera valores nulos ou com menos de 5 caracteres para
  /// nunca lançar dentro do `catch` e sempre devolver a falha ao chamador.
  String _cpfId(String? cpf) {
    if (cpf == null) return '';
    return cpf.length <= 5 ? cpf : cpf.substring(0, 5);
  }

  Failure _mapApiFailure(ApiFailure err) {
    if (err.status == 403)
      return ForbidenTokenFailure(
          err.title ?? err.detail ?? "forbiden_token_failure", err);
    if (err.failure == AuthenticationApi.invalid_credentials_failure)
      return InvalidCredentialsFailure(
          err.title ?? err.detail ?? "invalid_credentials_failure", err);
    if (err.failure == AuthenticationApi.unknow_credentials_failure)
      return UnknowCredentialsFailure(
          err.title ?? err.detail ?? "unknow_credentials_failure", err);
    if (err.failure == AuthenticationApi.not_registered_credentials_failure)
      return NotRegisteredCredentialsFailure(
          err.title ?? err.detail ?? "not_registered_credentials_failure", err);
    if (err.failure == AuthenticationApi.no_role_for_credentials_failure)
      return NoRoleForCredentialsFailure(
          err.title ?? err.detail ?? "no_role_for_credentials_failure", err);
    return UnknownFailure(err);
  }

  @override
  Future<Try<String?>> deleteAccount() async {
    try {
      final result = await this.remoteDataSource.deleteAccount();
      return Success(result);
    } catch (error) {
      return Rejection(UnknownFailure(error));
    }
  }
}
