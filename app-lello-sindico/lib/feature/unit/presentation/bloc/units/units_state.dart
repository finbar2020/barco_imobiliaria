import 'package:essentials/essentials.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

abstract class UnitsState {}

class UnitsLoadingState extends UnitsState {}

class UnitsNewLoadingState extends UnitsState {}

class UnitsFailureState extends UnitsState {
  final Failure? error;

  UnitsFailureState({
    required this.error,
  });
}

class UnitsSuccessState extends UnitsState {
  final List<Unit> units;

  UnitsSuccessState({
    required this.units,
  });
}

class UnitsEmptyState extends UnitsState {}
