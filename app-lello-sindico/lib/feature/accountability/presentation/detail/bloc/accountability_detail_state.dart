// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:lello/feature/accountability/domain/entity/accountability_periods.dart';

import 'package:essentials/essentials.dart';

import '../../../domain/entity/accountability.dart';

abstract class AccountabilityDetailState {
  final String? condominiumId;

  AccountabilityDetailState({this.condominiumId});
}

class AccountabilityDetailLoadingState extends AccountabilityDetailState {}

class AccountabilityDetailFailedState extends AccountabilityDetailState {
  Failure error;
  String? condominiumId;
  AccountabilityPeriods? period;
  AccountabilityDetailFailedState({
    required this.error,
    this.condominiumId,
    this.period,
  }) : super(condominiumId: condominiumId);
}

class AccountabilityDetailLoadedState extends AccountabilityDetailState {
  Accountability accountability;
  String? condominiumId;
  AccountabilityPeriods? period;
  AccountabilityDetailLoadedState({
    required this.accountability,
    this.condominiumId,
    this.period,
  }) : super(condominiumId: condominiumId);
}

class AccountabilityDetailEmptyState extends AccountabilityDetailState {}

class AccountabilitySendRecommendationLoadingState
    extends AccountabilityDetailState {}

class AccountabilitySendRecommendationSuccessState
    extends AccountabilityDetailState {}

class AccountabilitySendRecommendationFailureState
    extends AccountabilityDetailState {
  final String message;

  AccountabilitySendRecommendationFailureState({required this.message});
}
