import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';
import 'package:lello/feature/resin/domain/repository/resin_repository.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_refunds/get_resin_refunds.dart';

class GetResinRefundsImpl extends GetResinRefunds {
  final ResinRepository repository;

  GetResinRefundsImpl({required this.repository});

  @override
  Future<Try<List<ResinRefund>>> call(GetResinRefundsParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return params.origin == DataOrigin.local
        ? await repository.getResinRefundsFromCache(params.condominiumId)
        : await repository.getResinRefunds(params.condominiumId, params.filter);
  }

  Failure? _validate(GetResinRefundsParams? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
