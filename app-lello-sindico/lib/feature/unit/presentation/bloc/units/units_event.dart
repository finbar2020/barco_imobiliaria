import 'package:essentials/essentials.dart';

import '../../../domain/entity/unit.dart';

abstract class UnitsEvent {}

class UnitsLoadingEvent extends UnitsEvent {}

class UnitsNewLoadingEvent extends UnitsEvent {}

class UnitsFailureEvent extends UnitsEvent {
  final Failure? error;

  UnitsFailureEvent({
    required this.error,
  });
}

class UnitsSuccessEvent extends UnitsEvent {
  final List<Unit> units;

  UnitsSuccessEvent({
    required this.units,
  });
}

class UnitsEmptyEvent extends UnitsEvent {}
