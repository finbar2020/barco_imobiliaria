part of shared_features;

abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object?> get props => [];
}

class ResetPasswordRequestEvent extends ResetPasswordEvent {
  final AppOriginEnum appOriginEnum;
  const ResetPasswordRequestEvent({required this.appOriginEnum});

  @override
  List<Object?> get props => [appOriginEnum];
}

class PasswordResetMyUserEvent extends ResetPasswordEvent {
  final String cpf;
  const PasswordResetMyUserEvent({required this.cpf});

  @override
  List<Object?> get props => [cpf];
}

class PasswordResetEvent extends ResetPasswordEvent {
  const PasswordResetEvent();
}

class ResetPasswordResettingPasswordEvent extends ResetPasswordEvent {
  final PasswordReset reset;
  final PasswordResetStep step;
  final String cpf;
  final CodeValidation? validation;

  const ResetPasswordResettingPasswordEvent(
      {required this.reset,
      required this.step,
      required this.cpf,
      required this.validation});

  @override
  List<Object?> get props => [reset, step, cpf, validation];
}

class ResetPasswordFailedEvent extends ResetPasswordEvent {
  final Failure error;
  final PasswordReset reset;
  final PasswordResetStep step;
  final String cpf;
  final CodeValidation? validation;

  const ResetPasswordFailedEvent(
      {required this.error,
      required this.reset,
      required this.step,
      required this.cpf,
      required this.validation});

  @override
  List<Object?> get props => [error, reset, step, cpf, validation];
}

class ResetPasswordSucceededEvent extends ResetPasswordEvent {
  final PasswordReset reset;
  final PasswordResetStep step;
  final String cpf;
  final CodeValidation? validation;

  const ResetPasswordSucceededEvent(
      {required this.reset,
      required this.step,
      required this.cpf,
      required this.validation});

  @override
  List<Object?> get props => [reset, step, cpf, validation];
}

class ResetPasswordRequestingCodeEvent extends ResetPasswordEvent {
  final PasswordReset reset;
  final PasswordResetStep step;
  final String cpf;

  const ResetPasswordRequestingCodeEvent(
      {required this.reset, required this.step, required this.cpf});

  @override
  List<Object?> get props => [reset, step, cpf];
}

class ResetPasswordRequestCodeFailedEvent extends ResetPasswordEvent {
  final PasswordReset reset;
  final PasswordResetStep step;
  final String cpf;
  final Failure error;

  const ResetPasswordRequestCodeFailedEvent(
      {required this.reset,
      required this.step,
      required this.cpf,
      required this.error});

  @override
  List<Object?> get props => [reset, step, cpf, error];
}

class ResetPasswordRequestCodeSucceededEvent extends ResetPasswordEvent {
  final PasswordReset reset;
  final PasswordResetStep step;
  final String cpf;
  final CodeRequest codeRequest;

  const ResetPasswordRequestCodeSucceededEvent(
      {required this.reset,
      required this.step,
      required this.cpf,
      required this.codeRequest});

  @override
  List<Object?> get props => [reset, step, cpf, codeRequest];
}

class ResetPasswordRevertEvent extends ResetPasswordEvent {
  final PasswordReset reset;
  final PasswordResetStep step;
  final String cpf;

  const ResetPasswordRevertEvent(
      {required this.reset, required this.step, required this.cpf});

  @override
  List<Object?> get props => [reset, step, cpf];
}

class ResetPasswordMyUserLoadingEvent extends ResetPasswordEvent {
  final String cpf;
  final PasswordReset reset;
  final PasswordResetStep step;

  const ResetPasswordMyUserLoadingEvent(
      {required this.cpf, required this.reset, required this.step});

  @override
  List<Object?> get props => [cpf, reset, step];
}

class ResetPasswordMyUserFailedEvent extends ResetPasswordEvent {
  final PasswordReset reset;
  final PasswordResetStep step;
  final String cpf;
  final Failure? error;

  const ResetPasswordMyUserFailedEvent(
      {required this.reset,
      required this.step,
      required this.cpf,
      required this.error});

  @override
  List<Object?> get props => [reset, step, cpf, error];
}

class ResetPasswordMyUserNoPhoneFailedEvent extends ResetPasswordEvent {
  final PasswordReset reset;
  final PasswordResetStep step;
  final String cpf;
  final Failure? error;

  const ResetPasswordMyUserNoPhoneFailedEvent(
      {required this.reset,
      required this.step,
      required this.cpf,
      required this.error});

  @override
  List<Object?> get props => [reset, step, cpf, error];
}

class ResetPasswordMyUserNotRegisteredFailedEvent extends ResetPasswordEvent {
  final PasswordReset reset;
  final PasswordResetStep step;
  final String cpf;
  final Failure? error;

  const ResetPasswordMyUserNotRegisteredFailedEvent(
      {required this.reset,
      required this.step,
      required this.cpf,
      required this.error});

  @override
  List<Object?> get props => [reset, step, cpf, error];
}

class ResetPasswordMyUserSucceededEvent extends ResetPasswordEvent {
  final CodeData codeData;
  final String selectedValue;
  final CodeValidationSource? type;
  final PasswordReset reset;
  final PasswordResetStep step;
  final String cpf;
  const ResetPasswordMyUserSucceededEvent(
      {required this.codeData,
      required this.selectedValue,
      required this.type,
      required this.reset,
      required this.step,
      required this.cpf});

  @override
  List<Object?> get props =>
      [codeData, selectedValue, type, reset, step, cpf];
}

class ResetPasswordCodeValidatedEvent extends ResetPasswordEvent {
  final CodeValidation validation;
  final PasswordReset reset;
  final PasswordResetStep step;
  final String cpf;
  const ResetPasswordCodeValidatedEvent(
      {required this.validation,
      required this.reset,
      required this.step,
      required this.cpf});

  @override
  List<Object?> get props => [validation, reset, step, cpf];
}

class PasswordResetChangeStepEvent extends ResetPasswordEvent {
  final PasswordReset reset;
  final PasswordResetStep step;
  final String cpf;
  const PasswordResetChangeStepEvent(
      {required this.reset, required this.step, required this.cpf});

  @override
  List<Object?> get props => [reset, step, cpf];
}
