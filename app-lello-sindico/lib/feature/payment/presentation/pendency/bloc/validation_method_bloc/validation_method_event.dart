import 'package:essentials/functional/failure.dart';

abstract class ValidationMethodEvent {}

class ValidationMethodEmptyEvent extends ValidationMethodEvent {}

class ValidationMethodLoadingEvent extends ValidationMethodEvent {}

class ValidationMethodSuccessEvent extends ValidationMethodEvent {
  final int? id;
  ValidationMethodSuccessEvent({this.id});
}

class ValidationMethodFailureEvent extends ValidationMethodEvent {
  final Failure? error;
  ValidationMethodFailureEvent({this.error});
}
