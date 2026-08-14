part of shared_features;

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc() : super(const RegistrationEmptyState()) {
    on<RegistrationEmptyEvent>(handleRegistrationEmptyEvent);
    on<RegistrationSucceededEvent>(handleRegistrationSucceededEvent);
    on<RegistrationLoadingEvent>(handleRegistrationLoadingEvent);
    on<RegistrationCodeRequestLoadingEvent>(
        handleRegistrationCodeRequestLoadingEvent);
    on<RegistrationCodeRequestFailedEvent>(
        handleRegistrationCodeRequestFailedEvent);
    on<RegistrationRequestMyUserFailedEvent>(
        handleRegistrationRequestMyUserFailedEvent);
    on<RegistrationRequestMyUserLoadingEvent>(
        handleRegistrationRequestMyUserLoadingEvent);
    on<RegistrationRequestMyUserSucceededEvent>(
        handleRegistrationRequestMyUserSucceededEvent);
    on<RegistrationCodeRequestSucceededEvent>(
        handleRegistrationCodeRequestSucceededEvent);
    on<RegistrationFailedEvent>(handleRegistrationFailedEvent);
    on<RegistrationAuthFailedEvent>(handleRegistrationAuthFailedEvent);
  }

  void handleRegistrationEmptyEvent(
      RegistrationEmptyEvent event, Emitter<RegistrationState> emit) {
    emit(const RegistrationEmptyState());
  }

  void handleRegistrationSucceededEvent(
      RegistrationSucceededEvent event, Emitter<RegistrationState> emit) {
    emit(const RegistrationSucceededState());
  }

  void handleRegistrationLoadingEvent(
      RegistrationLoadingEvent event, Emitter<RegistrationState> emit) {
    emit(const RegistrationLoadingState());
  }

  void handleRegistrationCodeRequestLoadingEvent(
      RegistrationCodeRequestLoadingEvent event,
      Emitter<RegistrationState> emit) {
    emit(const RegistrationCodeRequestLoadingState());
  }

  void handleRegistrationCodeRequestFailedEvent(
      RegistrationCodeRequestFailedEvent event,
      Emitter<RegistrationState> emit) {
    emit(
      RegistrationCodeRequestFailedState(
        error: event.error,
      ),
    );
  }

  void handleRegistrationRequestMyUserFailedEvent(
      RegistrationRequestMyUserFailedEvent event,
      Emitter<RegistrationState> emit) {
    emit(
      RegistrationRequestMyUserFailedState(
        error: event.error,
      ),
    );
  }

  void handleRegistrationRequestMyUserLoadingEvent(
      RegistrationRequestMyUserLoadingEvent event,
      Emitter<RegistrationState> emit) {
    emit(
      RegistrationRequestMyUserLoadingState(
        loadingMessage: event.loadingMessage,
      ),
    );
  }

  void handleRegistrationRequestMyUserSucceededEvent(
      RegistrationRequestMyUserSucceededEvent event,
      Emitter<RegistrationState> emit) {
    emit(
      RegistrationRequestMyUserSucceededState(
        codeData: event.codeData,
        selectedValue: event.selectedValue,
        type: event.type,
      ),
    );
  }

  void handleRegistrationCodeRequestSucceededEvent(
      RegistrationCodeRequestSucceededEvent event,
      Emitter<RegistrationState> emit) {
    emit(RegistrationCodeRequestSucceededState(codeRequest: event.codeRequest));
  }

  void handleRegistrationFailedEvent(
      RegistrationFailedEvent event, Emitter<RegistrationState> emit) {
    emit(RegistrationFailedState(error: event.error));
  }

  void handleRegistrationAuthFailedEvent(
      RegistrationAuthFailedEvent event, Emitter<RegistrationState> emit) {
    emit(RegistrationAuthFailedState(error: event.error));
  }
}
