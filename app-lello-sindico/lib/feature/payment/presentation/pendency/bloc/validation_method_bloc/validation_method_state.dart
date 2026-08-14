import 'package:essentials/essentials.dart';

abstract class ValidationMethodState extends Equatable {
  const ValidationMethodState();

  @override
  List<Object?> get props => [];
}

class ValidationMethodEmptyState extends ValidationMethodState {
  const ValidationMethodEmptyState();
}

class ValidationMethodLoadingState extends ValidationMethodState {
  const ValidationMethodLoadingState();
}

class ValidationMethodSuccessState extends ValidationMethodState {
  final int? id;

  const ValidationMethodSuccessState({this.id});

  @override
  List<Object?> get props => [id];
}

class ValidationMethodFailureState extends ValidationMethodState {
  final Failure? error;

  const ValidationMethodFailureState({this.error});

  @override
  List<Object?> get props => [error];
}
