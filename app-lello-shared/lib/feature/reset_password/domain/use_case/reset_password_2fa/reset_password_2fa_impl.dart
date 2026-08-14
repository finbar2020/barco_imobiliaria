part of shared_features;

class ResetPassword2faImpl extends ResetPassword2fa {
  final PasswordResetRepository repository;

  ResetPassword2faImpl({required this.repository});

  @override
  Future<Try<PasswordReset>> call(ResetPassword2faParams params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return repository.post2fa(params);
  }

  Failure? validate(ResetPassword2faParams params) {
    if (params.cpf == null) return InvalidResetPassword2faFailure();
    if (params.cpf!.isEmpty) return InvalidResetPassword2faFailure();
    if (params.password == null) return InvalidResetPassword2faFailure();
    if (params.password!.isEmpty) return InvalidResetPassword2faFailure();
    return null;
  }
}
