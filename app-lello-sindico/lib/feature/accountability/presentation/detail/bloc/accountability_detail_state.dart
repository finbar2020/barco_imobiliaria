import 'package:essentials/essentials.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_periods.dart';

import '../../../domain/entity/accountability.dart';

abstract class AccountabilityDetailState extends Equatable {
  final String? condominiumId;

  const AccountabilityDetailState({this.condominiumId});

  @override
  List<Object?> get props => [condominiumId];
}

class AccountabilityDetailLoadingState extends AccountabilityDetailState {
  const AccountabilityDetailLoadingState();
}

class AccountabilityDetailFailedState extends AccountabilityDetailState {
  final Failure error;
  final AccountabilityPeriods? period;

  const AccountabilityDetailFailedState({
    required this.error,
    super.condominiumId,
    this.period,
  });

  @override
  List<Object?> get props => [error, condominiumId, period];
}

class AccountabilityDetailLoadedState extends AccountabilityDetailState {
  final Accountability accountability;
  final AccountabilityPeriods? period;

  const AccountabilityDetailLoadedState({
    required this.accountability,
    super.condominiumId,
    this.period,
  });

  @override
  List<Object?> get props => [accountability, condominiumId, period];
}

class AccountabilityDetailEmptyState extends AccountabilityDetailState {
  const AccountabilityDetailEmptyState();
}

class AccountabilitySendRecommendationLoadingState
    extends AccountabilityDetailState {
  const AccountabilitySendRecommendationLoadingState();
}

class AccountabilitySendRecommendationSuccessState
    extends AccountabilityDetailState {
  const AccountabilitySendRecommendationSuccessState();
}

class AccountabilitySendRecommendationFailureState
    extends AccountabilityDetailState {
  final String message;

  const AccountabilitySendRecommendationFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}
