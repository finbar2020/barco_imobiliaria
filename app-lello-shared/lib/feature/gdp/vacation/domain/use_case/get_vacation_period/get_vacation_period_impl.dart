import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_params.dart';
import 'package:shared_features/feature/gdp/vacation/domain/repository/vacation_repository.dart';
import 'package:shared_features/feature/gdp/vacation/domain/use_case/get_vacation_period/get_vacation_period.dart';

class GetVacationPeriodImpl extends GetVacationPeriod {
  final VacationRepository repository;

  GetVacationPeriodImpl({required this.repository});
  @override
  Future<Try<VacationParams>> call(GetVacationPeriodParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getVacationPeriod(
        params.condominiumId, params.employeeId);
  }

  Failure? _validate(GetVacationPeriodParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    if (param.employeeId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
