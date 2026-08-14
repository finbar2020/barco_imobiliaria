import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_coupon_request.dart';
import 'package:shared_features/feature/comfort/domain/repository/comfort_repository.dart';
import 'package:shared_features/feature/comfort/domain/use_case/create_coupon_request/create_coupon_request.dart';

class CreateCouponRequestUseCaseImpl extends CreateCouponRequestUseCase {
  final ComfortRepository repository;

  CreateCouponRequestUseCaseImpl({required this.repository});

  @override
  Future<Try<ComfortCouponRequest>> call(
      CreateCouponRequestUseCaseParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result = await repository.createCouponRequest(
        params.condominiumId, params.partnerId, params.couponId, params.unitId);

    return result;
  }

  Failure? validate(CreateCouponRequestUseCaseParam params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    if (params.partnerId.isEmpty) return InvalidParamFailure();
    //if (params.unitId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
