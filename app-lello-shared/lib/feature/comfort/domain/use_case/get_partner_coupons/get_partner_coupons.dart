import 'package:essentials/base/use_case.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_coupon.dart';

abstract class GetPartnerCouponsUseCase
    extends UseCase<List<ComfortPartnerCoupon>, GetPartnerCouponsParam> {}

class GetPartnerCouponsParam {
  String condominiumId;
  String partnerId;
  GetPartnerCouponsParam({required this.condominiumId, required this.partnerId});
}
