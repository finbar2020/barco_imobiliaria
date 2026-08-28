part of shared_features;

class RegistrationRepositoryImpl extends RegistrationRepository {
  final RegistrationRemoteDataSource dataSource;

  RegistrationRepositoryImpl({required this.dataSource});

  @override
  Future<Try<Registration>> post(Registration entity) async {
    try {
      final model = RegistrationModel.fromEntity(entity);
      final result = await dataSource.post(model!, entity.idEmpresa);
      return Success<Registration>(result.toEntity());
    } on ApiFailure catch (ex) {
      return Rejection(_mapApiFailure(ex));
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'cpfId: ${_cpfId(entity.cpf)}',
      );
      return Rejection<Registration>(UnknownFailure(e));
    }
  }

  @override
  Future<Try<RegistrationLelloUser>> get(String cpf) async {
    try {
      final result = await dataSource.get(cpf);
      return Success<RegistrationLelloUser>(result.toEntity());
    } on ApiFailure catch (ex) {
      return Rejection(_mapApiFailure(ex));
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'cpfId: ${_cpfId(cpf)}',
      );
      return Rejection<RegistrationLelloUser>(UnknownFailure(e));
    }
  }

  @override
  Future<Try<RegisterFcmToken>> registerFcmToken(
      RegisterFcmToken registerFcmToken) async {
    try {
      final model = RegisterFcmTokenModel.fromEntity(registerFcmToken);
      final result = await dataSource.registerFcmToken(model!);
      return Success<RegisterFcmToken>(result.toEntity());
    } on ApiFailure catch (ex) {
      return Rejection(_mapApiFailure(ex));
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'reference: ${registerFcmToken.reference}',
      );
      return Rejection<RegisterFcmToken>(UnknownFailure(e));
    }
  }

  /// Prefixo do cpf usado apenas para identificar o erro no Crashlytics.
  /// Tolera cpf nulo ou menor que 5 caracteres para nunca lançar dentro do
  /// `catch` e sempre devolver a falha ao chamador.
  String _cpfId(String? cpf) {
    if (cpf == null) return '';
    return cpf.length <= 5 ? cpf : cpf.substring(0, 5);
  }

  Failure _mapApiFailure(ApiFailure err) {
    if (err.failure == RegistrationApi.user_not_found_failure)
      return RegistrationUserNotFoundFailure();
    if (err.failure == RegistrationApi.user_already_registerd_failure)
      return RegistrationUserAlreadyRegisteredFailure();
    return UnknownFailure(err);
  }

  @override
  Future<Try<bool>> disableFcmToken(RegisterFcmToken registerFcmToken) async {
    try {
      final model = RegisterFcmTokenModel.fromEntity(registerFcmToken);
      final result = await dataSource.disableFcmToken(model!);
      return Success<bool>(result);
    } on ApiFailure catch (ex) {
      return Rejection(_mapApiFailure(ex));
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'reference: ${registerFcmToken.reference}',
      );
      return Rejection<bool>(UnknownFailure(e));
    }
  }
}
