import 'package:equatable/equatable.dart';

abstract class IaBellaEvent extends Equatable {
  const IaBellaEvent();

  @override
  List<Object?> get props => [];
}

class IaBellaEmptyEvent extends IaBellaEvent {
  const IaBellaEmptyEvent();
}

class IaBellaLoadingEvent extends IaBellaEvent {
  const IaBellaLoadingEvent();
}

class IaBellaLoadedEvent extends IaBellaEvent {
  final List<String> messages;

  const IaBellaLoadedEvent(this.messages);

  @override
  List<Object?> get props => [messages];
}

class IaBellaStartSessionEvent extends IaBellaEvent {
  const IaBellaStartSessionEvent();
}

class IaBellaStartSessionErrorEvent extends IaBellaEvent {
  const IaBellaStartSessionErrorEvent();
}

class IaBellaSessionStartedEvent extends IaBellaEvent {
  final String sessionId;

  const IaBellaSessionStartedEvent(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class IaBellaFinalEvaluationEvent extends IaBellaEvent {
  const IaBellaFinalEvaluationEvent();
}

class IaBellaFinalEvaluationErrorEvent extends IaBellaEvent {
  const IaBellaFinalEvaluationErrorEvent();
}

class IaBellaFinalEvaluationSuccessEvent extends IaBellaEvent {
  const IaBellaFinalEvaluationSuccessEvent();
}

class IaBellaDownloadPdfEvent extends IaBellaEvent {
  final String documentId;

  const IaBellaDownloadPdfEvent(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

class IaBellaDownloadingEvent extends IaBellaEvent {
  final String documentId;

  const IaBellaDownloadingEvent(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

class IaBellaDownloadPdfSuccessEvent extends IaBellaEvent {
  final String documentId;

  const IaBellaDownloadPdfSuccessEvent(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

class IaBellaRenderPdfEvent extends IaBellaEvent {
  final String documentId;

  const IaBellaRenderPdfEvent(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

class IaBellaRenderingPdfEvent extends IaBellaEvent {
  final String documentId;

  const IaBellaRenderingPdfEvent(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

class IaBellaRenderPdfSuccessEvent extends IaBellaEvent {
  final String documentId;

  const IaBellaRenderPdfSuccessEvent(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

class IaBellaSendMessageEvent extends IaBellaEvent {
  final String message;

  const IaBellaSendMessageEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class IaBellaRateMessageEvent extends IaBellaEvent {
  final String responseId;

  const IaBellaRateMessageEvent(this.responseId);

  @override
  List<Object?> get props => [responseId];
}

class IaBellaRateMessageSuccessEvent extends IaBellaEvent {
  final String responseId;

  const IaBellaRateMessageSuccessEvent(this.responseId);

  @override
  List<Object?> get props => [responseId];
}

class IaBellaErrorEvent extends IaBellaEvent {
  final String message;

  const IaBellaErrorEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class IaBellaReceiveMessageEvent extends IaBellaEvent {
  final String response;

  const IaBellaReceiveMessageEvent(this.response);

  @override
  List<Object?> get props => [response];
}
