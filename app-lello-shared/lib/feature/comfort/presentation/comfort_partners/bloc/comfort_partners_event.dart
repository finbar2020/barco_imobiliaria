import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_coupon_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_purchase.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_your_condo_remote_config.dart';

abstract class ComfortPartnersEvent extends Equatable {
  const ComfortPartnersEvent();

  @override
  List<Object?> get props => [];
}

class EmptyComfortPartnersEvent extends ComfortPartnersEvent {
  const EmptyComfortPartnersEvent();
}

class LoadingComfortPartnersEvent extends ComfortPartnersEvent {
  const LoadingComfortPartnersEvent();
}

class SuccessComfortPartnersEvent extends ComfortPartnersEvent {
  final ComfortPartner selectedPartner;

  const SuccessComfortPartnersEvent({required this.selectedPartner});

  @override
  List<Object?> get props => [selectedPartner];
}

class ErrorComfortPartnersEvent extends ComfortPartnersEvent {
  final String errorMessageKey;
  final String? errorDescription;
  final String? errorCode;

  const ErrorComfortPartnersEvent(
      {required this.errorMessageKey,
      required this.errorCode,
      required this.errorDescription});

  @override
  List<Object?> get props => [errorMessageKey, errorDescription, errorCode];
}

class LoadedComfortPartnersEvent extends ComfortPartnersEvent {
  final String? flushbarMessage;
  final bool comfortPartnerCategoryIsFilter;
  final bool comfortPartnersIsRandomic;
  final List<ComfortYourCondoRemoteConfig> categoriesToYourCondo;
  final bool isSuccessYourCondoPartners;
  final bool isFailedCondoPartners;
  final ComfortPartner? partnerFocus;

  const LoadedComfortPartnersEvent({
    this.flushbarMessage,
    required this.comfortPartnerCategoryIsFilter,
    required this.comfortPartnersIsRandomic,
    required this.categoriesToYourCondo,
    this.isSuccessYourCondoPartners = false,
    this.isFailedCondoPartners = false,
    this.partnerFocus,
  });

  @override
  List<Object?> get props => [
        flushbarMessage,
        comfortPartnerCategoryIsFilter,
        comfortPartnersIsRandomic,
        categoriesToYourCondo,
        isSuccessYourCondoPartners,
        isFailedCondoPartners,
        partnerFocus,
      ];
}

class LoadedComfortPartnerDetailsEvent extends ComfortPartnersEvent {
  final ComfortPartner selectedPartner;
  final ComfortCouponRequest? couponRequest;
  final ComfortRequestPurchase? requestPurchase;
  final String? error;

  const LoadedComfortPartnerDetailsEvent({
    required this.selectedPartner,
    this.couponRequest,
    this.requestPurchase,
    this.error,
  });

  @override
  List<Object?> get props =>
      [selectedPartner, couponRequest, requestPurchase, error];
}

class SuccessComfortPartnerCupomEvent extends LoadedComfortPartnerDetailsEvent {
  const SuccessComfortPartnerCupomEvent({
    required ComfortPartner selectedPartner,
    ComfortCouponRequest? couponRequest,
    ComfortRequestPurchase? requestPurchase,
    String? error,
  }) : super(
            selectedPartner: selectedPartner,
            couponRequest: couponRequest,
            requestPurchase: requestPurchase,
            error: error);
}

class LoadedComfortPartnerRequestErrorEvent
    extends LoadedComfortPartnerDetailsEvent {
  const LoadedComfortPartnerRequestErrorEvent({
    required ComfortPartner selectedPartner,
    ComfortCouponRequest? couponRequest,
    ComfortRequestPurchase? requestPurchase,
    String? error,
  }) : super(
            selectedPartner: selectedPartner,
            couponRequest: couponRequest,
            requestPurchase: requestPurchase,
            error: error);
}

class SuccessReviewSentEvent extends ComfortPartnersEvent {
  const SuccessReviewSentEvent();
}
