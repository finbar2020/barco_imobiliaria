import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_periods.dart';

abstract class GetTimesheetPeriodsUsecase
    extends UseCase<List<TimesheetPeriods>, GetTimesheetPeriodsParam> {}

class GetTimesheetPeriodsParam {
  final String condoId;

  GetTimesheetPeriodsParam({
    required this.condoId,
  });
}
