part of shared_features;

class InvalidCodeValidationFailure extends Failure {}

class InvalidRequestCodeFailure extends Failure {}

class ValidateCodeMaxAttemptsExceededFailure extends Failure {}

class RequestCodeAlreadyValidatedFailure extends Failure {}
