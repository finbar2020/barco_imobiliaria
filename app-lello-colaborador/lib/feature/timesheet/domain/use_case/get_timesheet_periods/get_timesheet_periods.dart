import 'package:colaborador/feature/timesheet/domain/entity/timesheet_periods.dart';
import 'package:essentials/essentials.dart';

abstract class GetTimesheetPeriodsUsecase
    extends UseCase<List<TimesheetPeriods>, GetTimesheetPeriodsParam> {}

class GetTimesheetPeriodsParam {
  final String condoId;

  GetTimesheetPeriodsParam({
    required this.condoId,
  });
}
