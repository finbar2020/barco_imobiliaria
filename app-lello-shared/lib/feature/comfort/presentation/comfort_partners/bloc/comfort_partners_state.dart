import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_coupon_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_purchase.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_your_condo_remote_config.dart';

abstract class ComfortPartnersState extends Equatable {
  const ComfortPartnersState();

  @override
  List<Object?> get props => [];
}

class EmptyComfortPartnersState extends ComfortPartnersState {
  const EmptyComfortPartnersState();
}

class LoadingComfortPartnersState extends ComfortPartnersState {
  const LoadingComfortPartnersState();
}

class SuccessComfortPartnersState extends ComfortPartnersState {
  final ComfortPartner selectedPartner;

  const SuccessComfortPartnersState({required this.selectedPartner});

  @override
  List<Object?> get props => [selectedPartner];
}

class ErrorComfortPartnersState extends ComfortPartnersState {
  final String errorMessageKey;
  final String? errorDescription;
  final String? errorCode;

  const ErrorComfortPartnersState(
      {required this.errorMessageKey,
      required this.errorCode,
      required this.errorDescription});

  @override
  List<Object?> get props => [errorMessageKey, errorDescription, errorCode];
}

class LoadedComfortState extends ComfortPartnersState {
  const LoadedComfortState();
}

class LoadedComfortPartnersState extends LoadedComfortState {
  final String? flushbarMessage;
  final bool comfortPartnerCategoryIsFilter;
  final bool comfortPartnersIsRandomic;
  final List<ComfortYourCondoRemoteConfig> categoriesToYourCondo;
  final bool isSuccessYourCondoPartners;
  final bool isFailedCondoPartners;
  final ComfortPartner? partnerFocus;

  const LoadedComfortPartnersState({
    this.flushbarMessage,
    required this.comfortPartnerCategoryIsFilter,
    required this.comfortPartnersIsRandomic,
    required this.categoriesToYourCondo,
    this.isSuccessYourCondoPartners = false,
    this.isFailedCondoPartners = false,
    this.partnerFocus,
  }) : super();

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

class LoadedComfortPartnerDetailsState extends LoadedComfortState {
  final ComfortPartner selectedPartner;
  final ComfortCouponRequest? couponRequest;
  final ComfortRequestPurchase? requestPurchase;
  final String? error;

  const LoadedComfortPartnerDetailsState({
    required this.selectedPartner,
    this.couponRequest,
    this.requestPurchase,
    this.error,
  }) : super();

  @override
  List<Object?> get props =>
      [selectedPartner, couponRequest, requestPurchase, error];
}

class SuccessComfortPartnerCupomState extends LoadedComfortPartnerDetailsState {
  const SuccessComfortPartnerCupomState({
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

class SuccessReviewSentState extends ComfortPartnersState {
  const SuccessReviewSentState();
}
