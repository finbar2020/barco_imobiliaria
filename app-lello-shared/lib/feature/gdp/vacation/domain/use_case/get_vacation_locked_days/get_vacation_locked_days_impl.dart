import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_locked_days.dart';
import 'package:shared_features/feature/gdp/vacation/domain/repository/vacation_repository.dart';
import 'package:shared_features/feature/gdp/vacation/domain/use_case/get_vacation_locked_days/get_vacation_locked_days.dart';

class GetLockedDaysImpl extends GetLockedDays {
  final VacationRepository repository;

  GetLockedDaysImpl({required this.repository});

  @override
  Future<Try<VacationLockedDays>> call(GetLockedDaysParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getLockedDays(params.condominiumId,
        params.employeeId, params.startDate!, params.endDate!);
  }

  Failure? _validate(GetLockedDaysParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    if (param.employeeId.isEmpty) return InvalidParamFailure();
    if (param.startDate == null) return InvalidParamFailure();
    if (param.endDate == null) return InvalidParamFailure();
    return null;
  }
}
