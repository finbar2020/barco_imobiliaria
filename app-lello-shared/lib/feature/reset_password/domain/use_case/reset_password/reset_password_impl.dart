part of shared_features;

class ResetPasswordImpl extends ResetPassword {
  final PasswordResetRepository repository;

  ResetPasswordImpl({required this.repository});

  @override
  Future<Try<PasswordReset>> call(PasswordReset params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return repository.post(params);
  }

  Failure? validate(PasswordReset params) {
    if (params.cpf == null) return InvalidCpfFailure();
    if (params.cpf!.isEmpty) return InvalidCpfFailure();
    if (params.password == null) return InvalidPasswordFailure();
    if (params.password!.isEmpty) return InvalidPasswordFailure();
    return null;
  }
}
