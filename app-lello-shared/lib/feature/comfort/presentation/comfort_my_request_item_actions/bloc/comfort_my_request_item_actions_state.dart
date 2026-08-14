part of 'comfort_my_request_item_actions_bloc.dart';

@immutable
abstract class ComfortMyRequestItemActionsState extends Equatable {
  const ComfortMyRequestItemActionsState();

  @override
  List<Object?> get props => [];
}

final class ComfortMyRequestItemActionsInitialState
    extends ComfortMyRequestItemActionsState {
  const ComfortMyRequestItemActionsInitialState();
}

final class ComfortMyRequestItemActionsLoadedState
    extends ComfortMyRequestItemActionsState {
  final ComfortCompletedRequest request;

  const ComfortMyRequestItemActionsLoadedState(this.request);

  @override
  List<Object?> get props => [request];
}

final class ComfortMyRequestItemActionsLoadingState
    extends ComfortMyRequestItemActionsLoadedState {
  final ComfortMyRequestItemActions action;

  const ComfortMyRequestItemActionsLoadingState(
      this.action, ComfortCompletedRequest request)
      : super(request);

  @override
  List<Object?> get props => [...super.props, action];
}

final class ComfortMyRequestItemActionsErrorState
    extends ComfortMyRequestItemActionsLoadedState {
  final ComfortMyRequestItemActions action;
  final String errorMessageKey;
  final String? errorDescription;
  final String? errorCode;

  const ComfortMyRequestItemActionsErrorState({
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

final class ComfortMyRequestItemActionsSuccessState
    extends ComfortMyRequestItemActionsLoadedState {
  final ComfortMyRequestItemActions action;

  const ComfortMyRequestItemActionsSuccessState(
      this.action, ComfortCompletedRequest request)
      : super(request);

  @override
  List<Object?> get props => [...super.props, action];
}
