import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_coupon_request.dart';

abstract class CreateCouponRequestUseCase
    extends UseCase<ComfortCouponRequest, CreateCouponRequestUseCaseParam> {}

class CreateCouponRequestUseCaseParam {
  String condominiumId;
  String partnerId;
  String unitId;
  String? couponId;

  CreateCouponRequestUseCaseParam({
    required this.condominiumId,
    required this.partnerId,
    required this.unitId,
    this.couponId,
  });
}
