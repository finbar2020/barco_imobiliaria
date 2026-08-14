import 'package:essentials/essentials.dart';
import 'package:morar/feature/accountability/domain/entity/accountability.dart';

abstract class AccountabilityEvent extends Equatable {
  const AccountabilityEvent();

  @override
  List<Object?> get props => [];
}

class AccountabilityLoadingEvent extends AccountabilityEvent {
  const AccountabilityLoadingEvent();
}

class AccountabilityEmptyEvent extends AccountabilityEvent {
  const AccountabilityEmptyEvent();
}

class AccountabilityLoadedEvent extends AccountabilityEvent {
  final List<String> periodos;

  const AccountabilityLoadedEvent({required this.periodos});

  @override
  List<Object?> get props => [periodos];
}

class AccountabilityFailureEvent extends AccountabilityEvent {
  final Failure? error;

  const AccountabilityFailureEvent({required this.error});

  @override
  List<Object?> get props => [error];
}

class AccountabilityPeriodsLoadedEvent extends AccountabilityEvent {
  final Accountability accountability;

  const AccountabilityPeriodsLoadedEvent({required this.accountability});

  @override
  List<Object?> get props => [accountability];
}
