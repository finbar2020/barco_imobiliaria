part of shared_features;

abstract class PasswordResetRepository {
  Future<Try<PasswordReset>> post(PasswordReset reset);
  Future<Try<PasswordReset>> post2fa(ResetPassword2faParams params);
}
