import 'package:equatable/equatable.dart';

abstract class IaBellaState extends Equatable {
  const IaBellaState();

  @override
  List<Object?> get props => [];
}

class IaBellaInitialState extends IaBellaState {
  const IaBellaInitialState();
}

class IaBellaLoadingState extends IaBellaState {
  const IaBellaLoadingState();
}

class IaBellaLoadedState extends IaBellaState {
  final List<String> messages;

  const IaBellaLoadedState(this.messages);

  @override
  List<Object?> get props => [messages];
}

class IaBellaStartSessionState extends IaBellaState {
  const IaBellaStartSessionState();
}

class IaBellaStartSessionErrorState extends IaBellaState {
  const IaBellaStartSessionErrorState();
}

class IaBellaSessionStartedState extends IaBellaState {
  final String sessionId;

  const IaBellaSessionStartedState(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class IaBellaFinalEvaluationState extends IaBellaState {
  const IaBellaFinalEvaluationState();
}

class IaBellaFinalEvaluationErrorState extends IaBellaState {
  const IaBellaFinalEvaluationErrorState();
}

class IaBellaFinalEvaluationSuccessState extends IaBellaState {
  const IaBellaFinalEvaluationSuccessState();
}

class IaBellaSendMessageState extends IaBellaState {
  final String message;

  const IaBellaSendMessageState(this.message);

  @override
  List<Object?> get props => [message];
}

class IaBellaReceiveMessageState extends IaBellaState {
  final String response;

  const IaBellaReceiveMessageState(this.response);

  @override
  List<Object?> get props => [response];
}

class IaBellaDownloadPdfState extends IaBellaState {
  final String documentId;

  const IaBellaDownloadPdfState(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

class IaBellaDownloadingState extends IaBellaState {
  final String documentId;

  const IaBellaDownloadingState(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

class IaBellaDownloadPdfSuccessState extends IaBellaState {
  const IaBellaDownloadPdfSuccessState();
}

class IaBellaRenderPdfState extends IaBellaState {
  final String documentId;

  const IaBellaRenderPdfState(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

class IaBellaRenderingPdfState extends IaBellaState {
  final String documentId;

  const IaBellaRenderingPdfState(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

class IaBellaRenderPdfSuccessState extends IaBellaState {
  final String documentId;

  const IaBellaRenderPdfSuccessState(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

class IaBellaRateMessageState extends IaBellaState {
  final String responseId;

  const IaBellaRateMessageState(this.responseId);

  @override
  List<Object?> get props => [responseId];
}

class IaBellaRateMessageSuccessState extends IaBellaState {
  final String responseId;

  const IaBellaRateMessageSuccessState(this.responseId);

  @override
  List<Object?> get props => [responseId];
}

class IaBellaErrorState extends IaBellaState {
  final String message;

  const IaBellaErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
