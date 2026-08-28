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
        reason: 'cpfId: ${_cpfId(reset.cpf)}',
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
        reason: 'cpfId: ${_cpfId(params.cpf)}',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  /// Prefixo do cpf usado apenas para identificar o erro no Crashlytics.
  /// Tolera cpf nulo ou menor que 5 caracteres para nunca lançar dentro do
  /// `catch` e sempre devolver a falha ao chamador.
  String _cpfId(String? cpf) {
    if (cpf == null) return '';
    return cpf.length <= 5 ? cpf : cpf.substring(0, 5);
  }
}
