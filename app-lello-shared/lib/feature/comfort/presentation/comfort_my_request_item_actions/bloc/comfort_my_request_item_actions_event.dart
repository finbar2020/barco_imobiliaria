part of 'comfort_my_request_item_actions_bloc.dart';

@immutable
abstract class ComfortMyRequestItemActionsEvent extends Equatable {
  const ComfortMyRequestItemActionsEvent();

  @override
  List<Object?> get props => [];
}

final class ComfortMyRequestItemActionsLoadedEvent
    extends ComfortMyRequestItemActionsEvent {
  final ComfortCompletedRequest request;

  const ComfortMyRequestItemActionsLoadedEvent(this.request);

  @override
  List<Object?> get props => [request];
}

final class ComfortMyRequestItemActionsLoadingEvent
    extends ComfortMyRequestItemActionsLoadedEvent {
  final ComfortMyRequestItemActions action;

  const ComfortMyRequestItemActionsLoadingEvent(
      ComfortCompletedRequest request, this.action)
      : super(request);

  @override
  List<Object?> get props => [...super.props, action];
}

final class ComfortMyRequestItemActionsErrorEvent
    extends ComfortMyRequestItemActionsLoadedEvent {
  final ComfortMyRequestItemActions action;
  final String errorMessageKey;
  final String? errorDescription;
  final String? errorCode;

  const ComfortMyRequestItemActionsErrorEvent({
    required ComfortCompletedRequest request,
    required this.action,
    required this.errorMessageKey,
    this.errorDescription,
    this.errorCode,
  }) : super(request);

  @override
  List<Object?> get props =>
      [...super.props, action, errorMessageKey, errorDescription, errorCode];
}

final class ComfortMyRequestItemActionsSuccessEvent
    extends ComfortMyRequestItemActionsLoadedEvent {
  final ComfortMyRequestItemActions action;

  const ComfortMyRequestItemActionsSuccessEvent(
      ComfortCompletedRequest request, this.action)
      : super(request);

  @override
  List<Object?> get props => [...super.props, action];
}
