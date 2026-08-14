import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_filter.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_report_day.dart';

abstract class GetReportDay
    extends UseCase<TimesheetReportDay, GetReportDayParam> {}

class GetReportDayParam {
  final String condominiumId;
  final TimesheetFilter filter;

  GetReportDayParam({required this.condominiumId, required this.filter});
}
