part of shared_features;

abstract class RegistrationFailure extends Failure {}

class InvalidRegistrationFailure extends RegistrationFailure {}

class RegistrationMissingRequiredDataFailure extends RegistrationFailure {
  final String field;

  RegistrationMissingRequiredDataFailure(this.field);
}

class RegistrationUserNotFoundFailure extends RegistrationFailure {
  RegistrationUserNotFoundFailure();
}

class RegistrationPhoneAndEmailFoundFailure extends RegistrationFailure {
  RegistrationPhoneAndEmailFoundFailure();
}

class RegistrationLockedRolloutFailure extends RegistrationFailure {
  RegistrationLockedRolloutFailure();
}

class RegistrationAuthFailure extends RegistrationFailure {
  RegistrationAuthFailure();
}

class RegistrationUserAlreadyRegisteredFailure extends RegistrationFailure {
  RegistrationUserAlreadyRegisteredFailure();
}
