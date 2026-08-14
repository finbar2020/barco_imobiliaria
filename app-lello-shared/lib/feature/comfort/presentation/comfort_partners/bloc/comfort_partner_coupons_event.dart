import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_coupon.dart';

abstract class ComfortPartnerCouponsEvent extends Equatable {
  const ComfortPartnerCouponsEvent();

  @override
  List<Object?> get props => [];
}

class EmptyCouponsEvent extends ComfortPartnerCouponsEvent {
  const EmptyCouponsEvent();
}

class LoadingCouponsEvent extends ComfortPartnerCouponsEvent {
  final String partnerId;
  final String condominiumId;

  const LoadingCouponsEvent(
      {required this.partnerId, required this.condominiumId});

  @override
  List<Object?> get props => [partnerId, condominiumId];
}

class LoadedCouponsEvent extends ComfortPartnerCouponsEvent {
  final List<ComfortPartnerCoupon> coupons;

  const LoadedCouponsEvent({required this.coupons});

  @override
  List<Object?> get props => [coupons];
}

class CouponsErrorEvent extends ComfortPartnerCouponsEvent {
  final String errorMessageKey;
  final String? errorDescription;
  final String? errorCode;

  const CouponsErrorEvent({
    required this.errorMessageKey,
    this.errorDescription,
    this.errorCode,
  });

  @override
  List<Object?> get props => [errorMessageKey, errorDescription, errorCode];
}
