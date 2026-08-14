import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_filter.dart';

abstract class ListTimesheet
    extends UseCase<List<Timesheet>, ListTimesheetParam> {}

class ListTimesheetParam {
  final String condominiumId;
  final TimesheetFilter filter;

  ListTimesheetParam({required this.condominiumId, required this.filter});
}
