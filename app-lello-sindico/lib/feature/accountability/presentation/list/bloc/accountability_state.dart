import 'package:essentials/essentials.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_periods.dart';

abstract class AccountabilityPeriodsState extends Equatable {
  const AccountabilityPeriodsState();

  @override
  List<Object?> get props => [];
}

class AccountabilityPeriodsLoadingState extends AccountabilityPeriodsState {
  const AccountabilityPeriodsLoadingState();
}

class AccountabilityPeriodsFailedState extends AccountabilityPeriodsState {
  final Failure error;

  const AccountabilityPeriodsFailedState({required this.error});

  @override
  List<Object?> get props => [error];
}

class AccountabilityPeriodsLoadedState extends AccountabilityPeriodsState {
  final List<AccountabilityPeriods> period;

  const AccountabilityPeriodsLoadedState({required this.period});

  @override
  List<Object?> get props => [period];
}

class AccountabilityPeriodsEmptyState extends AccountabilityPeriodsState {
  const AccountabilityPeriodsEmptyState();
}
