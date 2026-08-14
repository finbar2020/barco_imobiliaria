part of shared_features;

abstract class ResetPassword2fa
    extends UseCase<PasswordReset, ResetPassword2faParams> {}

class ResetPassword2faParams {
  String? cpf;
  String? password;
  String? token;
  ResetPassword2faParams({
    required this.cpf,
    required this.password,
    required this.token,
  });
}
