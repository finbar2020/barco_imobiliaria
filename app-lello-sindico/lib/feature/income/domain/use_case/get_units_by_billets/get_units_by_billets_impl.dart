import 'package:essentials/essentials.dart';
import 'package:lello/feature/income/data/repository/billets_repository.dart';
import 'package:lello/feature/income/domain/use_case/get_units_by_billets/get_units_by_billets.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

class GetUnitsByBilletsUseCaseImpl extends GetUnitsByBilletsUseCase {
  final BilletsRepository repository;

  GetUnitsByBilletsUseCaseImpl({required this.repository});

  @override
  Future<Try<List<Unit>>> call(GetUnitsByBilletsParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    final result =
        await repository.getUnitsByBillets(params.condominiumId, params.filter);
    return result;
  }

  Failure? validate(GetUnitsByBilletsParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
