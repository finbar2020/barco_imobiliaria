import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/shared_features.dart';

class FailureMessage {
  static String? get(BuildContext context, Failure failure) {
    if (failure is UnknownFailure) return getString(context, "error_unknown");

    if (failure is ServerConnectionFailure)
      return getString(context, "error_server_connection");
    if (failure is InvalidCredentialsFailure)
      return getString(context, "error_invalid_credentials");
    if (failure is InvalidCodeValidationFailure)
      return getString(context, "error_invalid_code");
    if (failure is ValidateCodeMaxAttemptsExceededFailure)
      return getString(context, "error_validation_code_max_attempts_exceeded");
    if (failure is RequestCodeAlreadyValidatedFailure)
      return getString(context, "error_invalid_code");
    if (failure is RegistrationUserNotFoundFailure)
      return getString(context, "error_registration_user_not_found");
    if (failure is RegistrationUserAlreadyRegisteredFailure)
      return getString(context, "error_registration_user_already_registered");
    return getString(context, "error_unknown");
  }
}
