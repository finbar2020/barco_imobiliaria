import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_coupon.dart';
import 'package:shared_features/feature/comfort/domain/repository/comfort_repository.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_partner_coupons/get_partner_coupons.dart';

class GetPartnerCouponsUseCaseImpl extends GetPartnerCouponsUseCase {
  final ComfortRepository repository;

  GetPartnerCouponsUseCaseImpl({required this.repository});

  @override
  Future<Try<List<ComfortPartnerCoupon>>> call(
      GetPartnerCouponsParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result = await repository.getPartnerCoupons(
        params.condominiumId, params.partnerId);

    return result;
  }

  Failure? validate(GetPartnerCouponsParam params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    if (params.partnerId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
