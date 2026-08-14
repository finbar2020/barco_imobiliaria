part of shared_features;

class CodeValidationBloc
    extends Bloc<CodeValidationEvent, CodeValidationState> {
  CodeValidationBloc() : super(const CodeValidationEmptyState()) {
    on<CodeValidationEmptyEvent>(handleCodeValidationEmptyEvent);
    on<CodeValidationSucceededEvent>(handleCodeValidationSucceededEvent);
    on<CodeValidationResendEvent>(handleCodeValidationResendEvent);
    on<CodeValidationFailedEvent>(handleCodeValidationFailedEvent);
    on<CodeValidationLoadingEvent>(handleCodeValidationLoadingEvent);
  }

  void handleCodeValidationEmptyEvent(
      CodeValidationEmptyEvent event, Emitter<CodeValidationState> emit) {
    emit(const CodeValidationEmptyState());
  }

  void handleCodeValidationLoadingEvent(
      CodeValidationLoadingEvent event, Emitter<CodeValidationState> emit) {
    emit(const CodeValidationValidatingState());
  }

  void handleCodeValidationSucceededEvent(
      CodeValidationSucceededEvent event, Emitter<CodeValidationState> emit) {
    emit(CodeValidationSucceededState(validation: event.validation));
  }

  void handleCodeValidationResendEvent(
      CodeValidationResendEvent event, Emitter<CodeValidationState> emit) {
    emit(CodeValidationResendState(validation: event.validation));
  }

  void handleCodeValidationFailedEvent(
      CodeValidationFailedEvent event, Emitter<CodeValidationState> emit) {
    emit(CodeValidationFailedState(error: event.error));
  }
}
