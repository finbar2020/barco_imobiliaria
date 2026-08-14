import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_coupon.dart';

abstract class ComfortPartnerCouponsState extends Equatable {
  const ComfortPartnerCouponsState();

  @override
  List<Object?> get props => [];
}

class EmptyCouponsState extends ComfortPartnerCouponsState {
  const EmptyCouponsState();
}

class LoadingCouponsState extends ComfortPartnerCouponsState {
  const LoadingCouponsState();
}

class LoadedCouponsState extends ComfortPartnerCouponsState {
  final List<ComfortPartnerCoupon> coupons;

  const LoadedCouponsState({required this.coupons});

  @override
  List<Object?> get props => [coupons];
}

class CouponsErrorState extends ComfortPartnerCouponsState {
  final String errorMessageKey;
  final String? errorDescription;
  final String? errorCode;

  const CouponsErrorState({
    required this.errorMessageKey,
    this.errorDescription,
    this.errorCode,
  });

  @override
  List<Object?> get props => [errorMessageKey, errorDescription, errorCode];
}
