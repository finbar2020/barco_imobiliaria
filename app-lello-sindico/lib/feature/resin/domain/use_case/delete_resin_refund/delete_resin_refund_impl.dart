import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/repository/resin_repository.dart';
import 'package:lello/feature/resin/domain/use_case/delete_resin_refund/delete_resin_refund.dart';

class DeleteResinRefundImpl extends DeleteResinRefund {
  final ResinRepository repository;

  DeleteResinRefundImpl({required this.repository});

  @override
  Future<Try<bool>> call(DeleteResinRefundParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.refundCancel(params.condominiumId, params.refundId);
  }

  Failure? _validate(DeleteResinRefundParams? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    if (param.refundId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
