import 'package:essentials/essentials.dart';
import 'package:lello/feature/income/data/repository/billets_repository.dart';
import 'package:lello/feature/income/domain/entity/billet.dart';

import 'get_billets.dart';

class GetBilletsImpl extends GetBillets {
  final BilletsRepository repository;

  GetBilletsImpl({required this.repository});

  @override
  Future<Try<Billet?>> call(GetBilletsParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    final result = await repository.get(
        params.condominiumId, params.unitId, params.period);
    return result;
  }

  Failure? validate(GetBilletsParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    if (params.unitId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
