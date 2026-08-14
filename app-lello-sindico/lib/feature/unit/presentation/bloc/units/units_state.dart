import 'package:essentials/essentials.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

abstract class UnitsState extends Equatable {
  const UnitsState();

  @override
  List<Object?> get props => [];
}

class UnitsLoadingState extends UnitsState {
  const UnitsLoadingState();
}

class UnitsNewLoadingState extends UnitsState {
  const UnitsNewLoadingState();
}

class UnitsFailureState extends UnitsState {
  final Failure? error;

  const UnitsFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class UnitsSuccessState extends UnitsState {
  final List<Unit> units;

  const UnitsSuccessState({required this.units});

  @override
  List<Object?> get props => [units];
}

class UnitsEmptyState extends UnitsState {
  const UnitsEmptyState();
}
