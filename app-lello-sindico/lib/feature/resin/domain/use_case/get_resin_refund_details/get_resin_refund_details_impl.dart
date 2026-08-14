import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';
import 'package:lello/feature/resin/domain/repository/resin_repository.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_refund_details/get_resin_refund_details.dart';

class GetResinRefundDetailsImpl extends GetResinRefundDetails {
  final ResinRepository repository;

  GetResinRefundDetailsImpl({required this.repository});

  @override
  Future<Try<ResinRefund>> call(GetResinRefundDetailsParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getResinRefundDetails(
        params.condominiumId, params.refundId);
  }

  Failure? _validate(GetResinRefundDetailsParams? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    if (param.refundId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
