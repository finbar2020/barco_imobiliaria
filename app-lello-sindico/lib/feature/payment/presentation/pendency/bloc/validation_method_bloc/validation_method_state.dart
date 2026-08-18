import 'package:essentials/functional/failure.dart';

abstract class ValidationMethodState {}

class ValidationMethodEmptyState extends ValidationMethodState {}

class ValidationMethodLoadingState extends ValidationMethodState {}

class ValidationMethodSuccessState extends ValidationMethodState {
  final int? id;
  ValidationMethodSuccessState({this.id});
}

class ValidationMethodFailureState extends ValidationMethodState {
  final Failure? error;
  ValidationMethodFailureState({this.error});
}
