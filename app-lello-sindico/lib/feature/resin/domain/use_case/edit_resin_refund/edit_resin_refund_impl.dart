import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/repository/resin_repository.dart';
import 'package:lello/feature/resin/domain/use_case/edit_resin_refund/edit_resin_refund.dart';

class EditResinRefundImpl extends EditResinRefund {
  final ResinRepository repository;

  EditResinRefundImpl({required this.repository});

  @override
  Future<Try<bool>> call(EditResinRefundParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.refundEdit(params.condominiumId, params.refund);
  }

  Failure? _validate(EditResinRefundParams? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
