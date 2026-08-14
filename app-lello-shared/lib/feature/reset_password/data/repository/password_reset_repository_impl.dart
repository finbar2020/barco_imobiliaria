part of shared_features;

class PasswordResetRepositoryImpl extends PasswordResetRepository {
  final PasswordResetRemoteDataSource dataSource;

  PasswordResetRepositoryImpl({required this.dataSource});

  @override
  Future<Try<PasswordReset>> post(PasswordReset reset) async {
    try {
      final model = PasswordResetModel.fromEntity(reset)!;
      final result = await dataSource.post(model);
      return Success(result.toEntity());
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'cpfId: ${reset.cpf!.substring(0, 5)}',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<PasswordReset>> post2fa(ResetPassword2faParams params) async {
    try {
      final model = PasswordResetModel.fromEntity(PasswordReset()
        ..cpf = params.cpf
        ..password = params.password
        ..token = params.token)!;
      final result = await dataSource.post(model);
      return Success(result.toEntity());
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'cpfId: ${params.cpf!.substring(0, 5)}',
      );
      return Rejection(UnknownFailure(e));
    }
  }
}
