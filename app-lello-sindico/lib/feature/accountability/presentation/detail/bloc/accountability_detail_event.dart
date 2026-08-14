import 'package:essentials/essentials.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_periods.dart';

import '../../../domain/entity/accountability.dart';

abstract class AccountabilityDetailEvent extends Equatable {
  const AccountabilityDetailEvent();

  @override
  List<Object?> get props => [];
}

class AccountabilityDetailLoadingEvent extends AccountabilityDetailEvent {
  const AccountabilityDetailLoadingEvent();
}

class AccountabilityDetailLoadedEvent extends AccountabilityDetailEvent {
  final Accountability accountability;
  final String condominiumId;
  final AccountabilityPeriods period;

  const AccountabilityDetailLoadedEvent({
    required this.accountability,
    required this.condominiumId,
    required this.period,
  });

  @override
  List<Object?> get props => [accountability, condominiumId, period];
}

class AccountabilityDetailFailedEvent extends AccountabilityDetailEvent {
  final Failure error;
  final String condominiumId;
  final AccountabilityPeriods period;

  const AccountabilityDetailFailedEvent({
    required this.error,
    required this.condominiumId,
    required this.period,
  });

  @override
  List<Object?> get props => [error, condominiumId, period];
}

class AccountabilityDetailEmptyEvent extends AccountabilityDetailEvent {
  const AccountabilityDetailEmptyEvent();
}

class AccountabilitySendRecommendationLoadingEvent
    extends AccountabilityDetailEvent {
  const AccountabilitySendRecommendationLoadingEvent();
}

class AccountabilitySendRecommendationSuccessEvent
    extends AccountabilityDetailEvent {
  const AccountabilitySendRecommendationSuccessEvent();
}

class AccountabilitySendRecommendationFailureEvent
    extends AccountabilityDetailEvent {
  final String message;

  const AccountabilitySendRecommendationFailureEvent({required this.message});

  @override
  List<Object?> get props => [message];
}
