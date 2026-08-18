import 'package:essentials/essentials.dart';

import '../../../domain/entity/accountability_periods.dart';

abstract class AccountabilityPeriodsEvent {}

class AccountabilityPeriodsLoadedEvent extends AccountabilityPeriodsEvent {
  final List<AccountabilityPeriods> period;
  AccountabilityPeriodsLoadedEvent({required this.period});
}

class AccountabilityPeriodsLoadingEvent extends AccountabilityPeriodsEvent {}

class AccountabilityPeriodsFailedEvent extends AccountabilityPeriodsEvent {
  final Failure failure;
  AccountabilityPeriodsFailedEvent({
    required this.failure,
  });
}

class AccountabilityPeriodsEmptyEvent extends AccountabilityPeriodsEvent {}
