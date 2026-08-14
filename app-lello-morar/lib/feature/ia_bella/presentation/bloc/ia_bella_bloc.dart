import 'package:flutter_bloc/flutter_bloc.dart';

import 'ia_bella_event.dart';
import 'ia_bella_state.dart';

class IaBellaBloc extends Bloc<IaBellaEvent, IaBellaState> {
  IaBellaBloc() : super(const IaBellaInitialState()) {
    on<IaBellaStartSessionEvent>(handleStartSession);
    on<IaBellaSessionStartedEvent>(handleSessionStarted);
    on<IaBellaStartSessionErrorEvent>(handleStartSessionError);
    on<IaBellaFinalEvaluationEvent>(handleFinalEvaluation);
    on<IaBellaFinalEvaluationErrorEvent>(handleFinalEvaluationError);
    on<IaBellaFinalEvaluationSuccessEvent>(handleFinalEvaluationSuccess);
    on<IaBellaSendMessageEvent>(handleSendMessage);
    on<IaBellaReceiveMessageEvent>(handleReceiveMessage);
    on<IaBellaErrorEvent>(handleError);
    on<IaBellaLoadingEvent>(handleLoading);
    on<IaBellaLoadedEvent>(handleLoaded);
    on<IaBellaRateMessageEvent>(handleRateResponse);
    on<IaBellaRateMessageSuccessEvent>(handleRateResponseSuccess);
    on<IaBellaDownloadPdfEvent>(handleDownloadPdf);
    on<IaBellaDownloadPdfSuccessEvent>(handleDownloadPdfSuccess);
    on<IaBellaRenderPdfEvent>(handleRenderPdf);
    on<IaBellaRenderPdfSuccessEvent>(handleRenderPdfSuccess);
  }

  void handleStartSession(
    IaBellaStartSessionEvent event,
    Emitter<IaBellaState> emit,
  ) {
    emit(const IaBellaStartSessionState());
  }

  void handleSessionStarted(
    IaBellaSessionStartedEvent event,
    Emitter<IaBellaState> emit,
  ) {
    emit(IaBellaLoadedState(["Sessão iniciada! ID: ${event.sessionId}"]));
  }

  void handleStartSessionError(
    IaBellaStartSessionErrorEvent event,
    Emitter<IaBellaState> emit,
  ) {
    emit(const IaBellaStartSessionErrorState());
  }

  void handleFinalEvaluation(
    IaBellaFinalEvaluationEvent event,
    Emitter<IaBellaState> emit,
  ) {
    emit(const IaBellaFinalEvaluationState());
  }

  void handleFinalEvaluationError(
    IaBellaFinalEvaluationErrorEvent event,
    Emitter<IaBellaState> emit,
  ) {
    emit(const IaBellaFinalEvaluationErrorState());
  }

  void handleFinalEvaluationSuccess(
    IaBellaFinalEvaluationSuccessEvent event,
    Emitter<IaBellaState> emit,
  ) {
    emit(const IaBellaFinalEvaluationSuccessState());
  }

  void handleSendMessage(
    IaBellaSendMessageEvent event,
    Emitter<IaBellaState> emit,
  ) {
    emit(const IaBellaLoadingState());
  }

  void handleReceiveMessage(
    IaBellaReceiveMessageEvent event,
    Emitter<IaBellaState> emit,
  ) {
    emit(IaBellaLoadedState([event.response]));
  }

  void handleError(IaBellaErrorEvent event, Emitter<IaBellaState> emit) {
    emit(IaBellaErrorState(event.message));
  }

  void handleLoading(IaBellaLoadingEvent event, Emitter<IaBellaState> emit) {
    emit(const IaBellaLoadingState());
  }

  void handleLoaded(IaBellaLoadedEvent event, Emitter<IaBellaState> emit) {
    emit(IaBellaLoadedState(event.messages));
  }

  void handleRateResponse(
    IaBellaRateMessageEvent event,
    Emitter<IaBellaState> emit,
  ) {
    emit(const IaBellaLoadingState());
  }

  void handleRateResponseSuccess(
    IaBellaRateMessageSuccessEvent event,
    Emitter<IaBellaState> emit,
  ) {
    emit(IaBellaRateMessageSuccessState(event.responseId));
  }

  void handleDownloadPdf(
    IaBellaDownloadPdfEvent event,
    Emitter<IaBellaState> emit,
  ) {
    emit(IaBellaDownloadingState(event.documentId));
  }

  void handleDownloadPdfSuccess(
    IaBellaDownloadPdfSuccessEvent event,
    Emitter<IaBellaState> emit,
  ) {
    emit(const IaBellaDownloadPdfSuccessState());
  }

  void handleRenderPdf(
    IaBellaRenderPdfEvent event,
    Emitter<IaBellaState> emit,
  ) {
    emit(IaBellaRenderingPdfState(event.documentId));
  }

  void handleRenderPdfSuccess(
    IaBellaRenderPdfSuccessEvent event,
    Emitter<IaBellaState> emit,
  ) {
    emit(IaBellaRenderPdfSuccessState(event.documentId));
  }
}
