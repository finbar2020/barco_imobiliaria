part of shared_features;

//TODO: Transformar em classe abstrata e passar do app para shared, igual app container
class FailureMessage {
  static String? get(BuildContext context, Failure failure) {
    if (failure is UnknownFailure) return getString(context, "error_unknown");

    if (failure is ServerConnectionFailure)
      return getString(context, "error_server_connection");
    if (failure is InvalidCredentialsFailure)
      return getString(context, "error_invalid_credentials");

    if (failure is UnknowCredentialsFailure)
      return getString(context, "error_invalid_credentials_unknow");
    if (failure is NotRegisteredCredentialsFailure)
      return getString(context, "error_invalid_credentials_not_registered");
    if (failure is NoRoleForCredentialsFailure)
      return getString(context, "error_invalid_credentials_no_role");

    if (failure is InvalidValue2faFailure)
      return getString(context, "error_invalid_code");
    if (failure is RegistrationUserNotFoundFailure)
      return getString(context, "error_registration_user_not_found");
    if (failure is RegistrationUserAlreadyRegisteredFailure)
      return getString(context, "error_registration_user_already_registered");
    return getString(context, "error_unknown");
  }
}
