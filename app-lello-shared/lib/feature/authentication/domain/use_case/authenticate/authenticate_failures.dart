part of shared_features;

abstract class AuthenticateFailure extends KnownFailure {
  AuthenticateFailure(super.code, super.err);
}

class InvalidCredentialsFailure extends AuthenticateFailure {
  InvalidCredentialsFailure(super.code, super.err);
}

class UnknowCredentialsFailure extends AuthenticateFailure {
  UnknowCredentialsFailure(super.code, super.err);
}

class NotRegisteredCredentialsFailure extends AuthenticateFailure {
  NotRegisteredCredentialsFailure(super.code, super.err);
}

class NoRoleForCredentialsFailure extends AuthenticateFailure {
  NoRoleForCredentialsFailure(super.code, super.err);
}

class BadRefreshTokenFailure extends AuthenticateFailure {
  BadRefreshTokenFailure(super.code, super.err);
}

class ForbidenTokenFailure extends AuthenticateFailure {
  ForbidenTokenFailure(super.code, super.err);
}
