import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';
import 'package:lello/feature/resin/domain/repository/resin_repository.dart';
import 'package:lello/feature/resin/domain/use_case/create_resin_refund/create_resin_refund.dart';

class CreateResinRefundImpl extends CreateResinRefund {
  final ResinRepository repository;

  CreateResinRefundImpl({required this.repository});

  @override
  Future<Try<ResinRefund>> call(CreateResinRefundParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.createResinRefund(
        params.condominiumId, params.refund);
  }

  Failure? _validate(CreateResinRefundParams? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
