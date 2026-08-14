import 'package:essentials/essentials.dart';

abstract class ValidationMethodEvent extends Equatable {
  const ValidationMethodEvent();

  @override
  List<Object?> get props => [];
}

class ValidationMethodEmptyEvent extends ValidationMethodEvent {
  const ValidationMethodEmptyEvent();
}

class ValidationMethodLoadingEvent extends ValidationMethodEvent {
  const ValidationMethodLoadingEvent();
}

class ValidationMethodSuccessEvent extends ValidationMethodEvent {
  final int? id;

  const ValidationMethodSuccessEvent({this.id});

  @override
  List<Object?> get props => [id];
}

class ValidationMethodFailureEvent extends ValidationMethodEvent {
  final Failure? error;

  const ValidationMethodFailureEvent({this.error});

  @override
  List<Object?> get props => [error];
}
