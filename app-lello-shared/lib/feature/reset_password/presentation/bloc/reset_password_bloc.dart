part of shared_features;

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc() : super(ResetPasswordRequestPhoneState.empty()) {
    on<PasswordResetChangeStepEvent>(handlePasswordResetChangeStepEvent);
    on<ResetPasswordCodeValidatedEvent>(handleResetPasswordCodeValidatedEvent);
    on<ResetPasswordFailedEvent>(handleResetPasswordFailedEvent);
    on<ResetPasswordMyUserFailedEvent>(handleResetPasswordMyUserFailedEvent);
    on<ResetPasswordMyUserLoadingEvent>(handleResetPasswordMyUserLoadingEvent);
    on<ResetPasswordMyUserNoPhoneFailedEvent>(
        handleResetPasswordMyUserNoPhoneFailedEvent);
    on<ResetPasswordMyUserNotRegisteredFailedEvent>(
        handleResetPasswordMyUserNotRegisteredFailedEvent);
    on<ResetPasswordMyUserSucceededEvent>(
        handleResetPasswordMyUserSucceededEvent);
    on<ResetPasswordRevertEvent>(handleResetPasswordRevertEvent);
    on<ResetPasswordRequestCodeFailedEvent>(
        handleResetPasswordRequestCodeFailedEvent);
    on<ResetPasswordRequestCodeSucceededEvent>(
        handleResetPasswordRequestCodeSucceededEvent);
    on<ResetPasswordRequestingCodeEvent>(
        handleResetPasswordRequestingCodeEvent);
    on<ResetPasswordResettingPasswordEvent>(
        handleResetPasswordResettingPasswordEvent);
    on<ResetPasswordSucceededEvent>(handleResetPasswordSucceededEvent);
  }

  void handlePasswordResetChangeStepEvent(
      PasswordResetChangeStepEvent event, Emitter<ResetPasswordState> emit) {
    emit(
      ResetPasswordState(event.reset, event.step, event.cpf),
    );
  }

  void handleResetPasswordCodeValidatedEvent(
      ResetPasswordCodeValidatedEvent event, Emitter<ResetPasswordState> emit) {
    emit(
      ResetPasswordRequestPasswordState(
          event.reset, event.step, event.cpf, event.validation),
    );
  }

  void handleResetPasswordFailedEvent(
      ResetPasswordFailedEvent event, Emitter<ResetPasswordState> emit) {
    emit(
      ResetPasswordFailedState(
          event.error, event.reset, event.step, event.cpf, event.validation),
    );
  }

  void handleResetPasswordMyUserFailedEvent(
      ResetPasswordMyUserFailedEvent event, Emitter<ResetPasswordState> emit) {
    emit(
      ResetPasswordMyUserFailedState(
          event.cpf, event.reset, event.step, event.error),
    );
  }

  void handleResetPasswordMyUserLoadingEvent(
      ResetPasswordMyUserLoadingEvent event, Emitter<ResetPasswordState> emit) {
    emit(
      ResetPasswordMyUserLoadingState(event.cpf, event.reset, event.step),
    );
  }

  void handleResetPasswordMyUserNoPhoneFailedEvent(
      ResetPasswordMyUserNoPhoneFailedEvent event, Emitter<ResetPasswordState> emit) {
    emit(
      ResetPasswordMyUserNoPhoneFailedState(
          event.cpf, event.reset, event.step, event.error),
    );
  }

  void handleResetPasswordMyUserNotRegisteredFailedEvent(
      ResetPasswordMyUserNotRegisteredFailedEvent event, Emitter<ResetPasswordState> emit) {
    emit(
      ResetPasswordMyUserNotRegisteredFailedState(
          event.cpf, event.reset, event.step, event.error),
    );
  }

  void handleResetPasswordMyUserSucceededEvent(
      ResetPasswordMyUserSucceededEvent event, Emitter<ResetPasswordState> emit) {
    emit(
      ResetPasswordMyUserSucceededState(event.codeData, event.selectedValue,
          event.type, event.reset, event.step, event.cpf),
    );
  }

  void handleResetPasswordRevertEvent(
      ResetPasswordRevertEvent event, Emitter<ResetPasswordState> emit) {
    emit(ResetPasswordRequestPhoneState(event.reset, event.step, event.cpf));
  }

  void handleResetPasswordRequestCodeFailedEvent(
      ResetPasswordRequestCodeFailedEvent event, Emitter<ResetPasswordState> emit) {
    emit(
      ResetPasswordRequestCodeFailedState(
          event.reset, event.step, event.cpf, event.error),
    );
  }

  void handleResetPasswordRequestCodeSucceededEvent(
      ResetPasswordRequestCodeSucceededEvent event, Emitter<ResetPasswordState> emit) {
    emit(
      ResetPasswordRequestCodeSucceededState(
          event.reset, event.step, event.cpf, event.codeRequest),
    );
  }

  void handleResetPasswordRequestingCodeEvent(
      ResetPasswordRequestingCodeEvent event, Emitter<ResetPasswordState> emit) {
    emit(
      ResetPasswordRequestingCodeState(event.reset, event.step, event.cpf),
    );
  }

  void handleResetPasswordResettingPasswordEvent(
      ResetPasswordResettingPasswordEvent event, Emitter<ResetPasswordState> emit) {
    emit(
      ResetPasswordResettingPasswordState(
          event.reset, event.step, event.cpf, event.validation),
    );
  }

  void handleResetPasswordSucceededEvent(
      ResetPasswordSucceededEvent event, Emitter<ResetPasswordState> emit) {
    emit(
      ResetPasswordSucceededState(
          event.reset, event.step, event.cpf, event.validation),
    );
  }
}
