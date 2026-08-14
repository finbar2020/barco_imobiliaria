import 'package:essentials/essentials.dart';
import 'package:morar/feature/accountability/domain/entity/accountability.dart';

abstract class AccountabilityState extends Equatable {
  const AccountabilityState();

  @override
  List<Object?> get props => [];
}

class AccountabilityInitialState extends AccountabilityState {
  const AccountabilityInitialState();
}

class AccountabilityLoadingState extends AccountabilityState {
  const AccountabilityLoadingState();
}

class AccountabilityLoadedState extends AccountabilityState {
  final List<String> periodos;

  const AccountabilityLoadedState({required this.periodos});

  @override
  List<Object?> get props => [periodos];
}

class AccountabilityPeriodsLoadedState extends AccountabilityState {
  final Accountability accountability;

  const AccountabilityPeriodsLoadedState({required this.accountability});

  @override
  List<Object?> get props => [accountability];
}

class AccountabilityFailureState extends AccountabilityState {
  final Failure? error;

  const AccountabilityFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}
