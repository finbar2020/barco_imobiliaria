import 'package:colaborador/feature/timesheet/domain/entity/timesheet_periods.dart';
import 'package:colaborador/feature/timesheet/domain/repository/timesheet_repository.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet_periods/get_timesheet_periods.dart';
import 'package:essentials/essentials.dart';

class GetTimesheetPeriodsUsecaseImpl extends GetTimesheetPeriodsUsecase {
  final TimesheetRepository repository;

  GetTimesheetPeriodsUsecaseImpl({required this.repository});
  @override
  Future<Try<List<TimesheetPeriods>>> call(
      GetTimesheetPeriodsParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return await repository.getTimesheetPeriods(params.condoId);
  }

  Failure? validate(GetTimesheetPeriodsParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condoId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
