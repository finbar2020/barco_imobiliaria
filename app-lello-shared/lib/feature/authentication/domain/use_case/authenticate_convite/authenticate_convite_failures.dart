part of shared_features;

abstract class AuthenticateConviteFailure extends Failure {}

class InvalidConviteCredentialsFailure extends AuthenticateConviteFailure {}
