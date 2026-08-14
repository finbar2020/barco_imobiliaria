part of shared_features;

class ResetPasswordState extends Equatable {
  final PasswordReset reset;
  final PasswordResetStep step;
  String cpf;

  ResetPasswordState(this.reset, this.step, this.cpf);

  @override
  List<Object?> get props => [reset, step, cpf];
}

class ResetPasswordEmptyState extends ResetPasswordState {
  ResetPasswordEmptyState(
      PasswordReset reset, PasswordResetStep step, String cpf)
      : super(reset, step, cpf);
}

abstract class ResetPasswordCodeValidatedState extends ResetPasswordState {
  final CodeValidation? validation;

  ResetPasswordCodeValidatedState(
      PasswordReset reset, PasswordResetStep step, String cpf, this.validation)
      : super(reset, step, cpf);

  @override
  List<Object?> get props => [...super.props, validation];
}

class ResetPasswordResettingPasswordState
    extends ResetPasswordCodeValidatedState {
  ResetPasswordResettingPasswordState(PasswordReset reset,
      PasswordResetStep step, String cpf, CodeValidation? validation)
      : super(reset, step, cpf, validation);
}

class ResetPasswordFailedState extends ResetPasswordCodeValidatedState {
  final Failure error;
  ResetPasswordFailedState(this.error, PasswordReset reset,
      PasswordResetStep step, String cpf, CodeValidation? validation)
      : super(reset, step, cpf, validation);

  @override
  List<Object?> get props => [...super.props, error];
}

class ResetPasswordSucceededState extends ResetPasswordCodeValidatedState {
  ResetPasswordSucceededState(PasswordReset reset, PasswordResetStep step,
      String cpf, CodeValidation? validation)
      : super(reset, step, cpf, validation);
}

class ResetPasswordRequestingCodeState extends ResetPasswordState {
  ResetPasswordRequestingCodeState(
      PasswordReset reset, PasswordResetStep step, String cpf)
      : super(reset, step, cpf);
}

class ResetPasswordRequestCodeFailedState extends ResetPasswordState {
  final Failure error;
  ResetPasswordRequestCodeFailedState(
      PasswordReset reset, PasswordResetStep step, String cpf, this.error)
      : super(reset, step, cpf);

  @override
  List<Object?> get props => [...super.props, error];
}

class ResetPasswordRequestCodeSucceededState extends ResetPasswordState {
  final CodeRequest codeRequest;
  ResetPasswordRequestCodeSucceededState(
      PasswordReset reset, PasswordResetStep step, String cpf, this.codeRequest)
      : super(reset, step, cpf);

  @override
  List<Object?> get props => [...super.props, codeRequest];
}

class ResetPasswordRequestPhoneState extends ResetPasswordState {
  ResetPasswordRequestPhoneState(
      PasswordReset reset, PasswordResetStep step, String cpf)
      : super(reset, step, cpf);
  factory ResetPasswordRequestPhoneState.empty() =>
      ResetPasswordRequestPhoneState(
          PasswordReset(), PasswordResetStep.cpf, "");
}

class ResetPasswordMyUserLoadingState extends ResetPasswordState {
  final String cpf;
  ResetPasswordMyUserLoadingState(
      this.cpf, PasswordReset reset, PasswordResetStep step)
      : super(reset, step, cpf);
}

class ResetPasswordMyUserFailedState extends ResetPasswordState {
  final Failure? error;
  final String cpf;
  ResetPasswordMyUserFailedState(
      this.cpf, PasswordReset reset, PasswordResetStep step, this.error)
      : super(reset, step, cpf);

  @override
  List<Object?> get props => [...super.props, error];
}

class ResetPasswordMyUserNoPhoneFailedState extends ResetPasswordState {
  final Failure? error;
  final String cpf;
  ResetPasswordMyUserNoPhoneFailedState(
      this.cpf, PasswordReset reset, PasswordResetStep step, this.error)
      : super(reset, step, cpf);

  @override
  List<Object?> get props => [...super.props, error];
}

class ResetPasswordMyUserNotRegisteredFailedState extends ResetPasswordState {
  final Failure? error;
  final String cpf;
  ResetPasswordMyUserNotRegisteredFailedState(
      this.cpf, PasswordReset reset, PasswordResetStep step, this.error)
      : super(reset, step, cpf);

  @override
  List<Object?> get props => [...super.props, error];
}

class ResetPasswordMyUserSucceededState extends ResetPasswordState {
  final CodeData codeData;
  String selectedValue;
  CodeValidationSource? type;
  ResetPasswordMyUserSucceededState(this.codeData, this.selectedValue,
      this.type, PasswordReset reset, PasswordResetStep step, String cpf)
      : super(reset, step, cpf);

  @override
  List<Object?> get props => [...super.props, codeData, selectedValue, type];
}

class ResetPasswordRequestPasswordState
    extends ResetPasswordCodeValidatedState {
  ResetPasswordRequestPasswordState(PasswordReset reset, PasswordResetStep step,
      String cpf, CodeValidation validation)
      : super(reset, step, cpf, validation);
}
