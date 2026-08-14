import 'package:essentials/essentials.dart';

abstract class InCareEvent extends Equatable {
  const InCareEvent();

  @override
  List<Object?> get props => [];
}

class InCareSendRequestEvent extends InCareEvent {
  const InCareSendRequestEvent();
}

class InCareSuccessEvent extends InCareEvent {
  const InCareSuccessEvent();
}

class InCareUpdateSuccessEvent extends InCareEvent {
  const InCareUpdateSuccessEvent();
}

class InCareFailureEvent extends InCareEvent {
  final String error;

  const InCareFailureEvent({required this.error});

  @override
  List<Object?> get props => [error];
}
