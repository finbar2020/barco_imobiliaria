// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:lello/feature/accountability/domain/entity/accountability_periods.dart';

import 'package:essentials/essentials.dart';

import '../../../domain/entity/accountability.dart';

abstract class AccountabilityDetailEvent {}

class AccountabilityDetailLoadingEvent extends AccountabilityDetailEvent {}

class AccountabilityDetailLoadedEvent extends AccountabilityDetailEvent {
  final Accountability accountability;
  final String condominiumId;
  final AccountabilityPeriods period;
  AccountabilityDetailLoadedEvent({
    required this.accountability,
    required this.condominiumId,
    required this.period,
  });
}

class AccountabilityDetailFailedEvent extends AccountabilityDetailEvent {
  final Failure error;
  final String condominiumId;
  final AccountabilityPeriods period;
  AccountabilityDetailFailedEvent({
    required this.error,
    required this.condominiumId,
    required this.period,
  });
}

class AccountabilityDetailEmptyEvent extends AccountabilityDetailEvent {}

class AccountabilitySendRecommendationLoadingEvent
    extends AccountabilityDetailEvent {}

class AccountabilitySendRecommendationSuccessEvent
    extends AccountabilityDetailEvent {}

class AccountabilitySendRecommendationFailureEvent
    extends AccountabilityDetailEvent {
  final String message;

  AccountabilitySendRecommendationFailureEvent({required this.message});
}
