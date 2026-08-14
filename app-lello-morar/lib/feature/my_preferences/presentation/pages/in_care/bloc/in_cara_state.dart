import 'package:essentials/essentials.dart';

abstract class InCareState extends Equatable {
  const InCareState();

  @override
  List<Object?> get props => [];
}

class InCareInitialState extends InCareState {
  const InCareInitialState();
}

class InCareLoadingState extends InCareState {
  const InCareLoadingState();
}

class InCareLoadedState extends InCareState {
  const InCareLoadedState();
}

class InCareUpdateSuccessState extends InCareState {
  const InCareUpdateSuccessState();
}

class InCareFailureState extends InCareState {
  final String error;

  const InCareFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}
