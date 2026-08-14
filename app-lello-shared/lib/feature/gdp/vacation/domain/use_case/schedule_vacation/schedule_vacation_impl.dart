import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_created.dart';
import 'package:shared_features/feature/gdp/vacation/domain/repository/vacation_repository.dart';
import 'package:shared_features/feature/gdp/vacation/domain/use_case/schedule_vacation/schedule_vacation.dart';

class ScheduleVacationImpl extends ScheduleVacation {
  final VacationRepository repository;

  ScheduleVacationImpl({required this.repository});

  @override
  Future<Try<VacationCreated>> call(ScheduleVacationParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return await repository.createVacation(
      condominiumId: params.condominiumId,
      employeeId: params.employeeId,
      vacationCreated: params.vacationCreated,
    );
  }

  Failure? validate(ScheduleVacationParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    if (param.employeeId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
