import 'package:essentials/essentials.dart';

import '../../../domain/entity/accountability_periods.dart';

abstract class AccountabilityPeriodsEvent extends Equatable {
  const AccountabilityPeriodsEvent();

  @override
  List<Object?> get props => [];
}

class AccountabilityPeriodsLoadedEvent extends AccountabilityPeriodsEvent {
  final List<AccountabilityPeriods> period;

  const AccountabilityPeriodsLoadedEvent({required this.period});

  @override
  List<Object?> get props => [period];
}

class AccountabilityPeriodsLoadingEvent extends AccountabilityPeriodsEvent {
  const AccountabilityPeriodsLoadingEvent();
}

class AccountabilityPeriodsFailedEvent extends AccountabilityPeriodsEvent {
  final Failure failure;

  const AccountabilityPeriodsFailedEvent({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class AccountabilityPeriodsEmptyEvent extends AccountabilityPeriodsEvent {
  const AccountabilityPeriodsEmptyEvent();
}
