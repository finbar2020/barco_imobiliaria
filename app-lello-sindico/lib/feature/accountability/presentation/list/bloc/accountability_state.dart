// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:lello/feature/accountability/domain/entity/accountability_periods.dart';

import 'package:essentials/essentials.dart';

abstract class AccountabilityPeriodsState {}

class AccountabilityPeriodsLoadingState extends AccountabilityPeriodsState {}

class AccountabilityPeriodsFailedState extends AccountabilityPeriodsState {
  final Failure error;
  AccountabilityPeriodsFailedState({
    required this.error,
  });
}

class AccountabilityPeriodsLoadedState extends AccountabilityPeriodsState {
  final List<AccountabilityPeriods> period;
  AccountabilityPeriodsLoadedState({
    required this.period,
  });
}

class AccountabilityPeriodsEmptyState extends AccountabilityPeriodsState {
  AccountabilityPeriodsEmptyState();
}
