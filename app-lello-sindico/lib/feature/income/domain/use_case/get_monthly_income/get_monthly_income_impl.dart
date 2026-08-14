import 'package:essentials/essentials.dart';
import 'package:lello/feature/income/domain/entity/income.dart';
import 'package:lello/feature/income/domain/repository/income_repository.dart';
import 'package:lello/feature/income/domain/use_case/get_monthly_income/get_income.dart';

class GetIncomeImpl extends GetIncome {
  final IncomeRepository repository;
  GetIncomeImpl({required this.repository});

  @override
  Future<Try<Income?>> call(GetIncomeParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.select(
        params.origin, params.condominiumId, params.period);
  }

  Failure? _validate(GetIncomeParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condominiumId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
