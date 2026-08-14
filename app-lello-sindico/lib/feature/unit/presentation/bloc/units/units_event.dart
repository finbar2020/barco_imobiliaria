import 'package:essentials/essentials.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

abstract class UnitsEvent extends Equatable {
  const UnitsEvent();

  @override
  List<Object?> get props => [];
}

class UnitsLoadingEvent extends UnitsEvent {
  const UnitsLoadingEvent();
}

class UnitsNewLoadingEvent extends UnitsEvent {
  const UnitsNewLoadingEvent();
}

class UnitsFailureEvent extends UnitsEvent {
  final Failure? error;

  const UnitsFailureEvent({required this.error});

  @override
  List<Object?> get props => [error];
}

class UnitsSuccessEvent extends UnitsEvent {
  final List<Unit> units;

  const UnitsSuccessEvent({required this.units});

  @override
  List<Object?> get props => [units];
}

class UnitsEmptyEvent extends UnitsEvent {
  const UnitsEmptyEvent();
}
