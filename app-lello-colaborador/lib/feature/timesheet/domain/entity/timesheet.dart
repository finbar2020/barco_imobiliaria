import 'package:colaborador/feature/timesheet/domain/entity/timesheet_element.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_status_enum.dart';

class Timesheet {
  DateTime dateFrom;
  DateTime dateTo;
  DateTime? dateLiberation;
  TimesheetStatusEnum timesheetStatus;
  List<TimesheetElement> timesheetElements;

  Timesheet({
    this.dateLiberation,
    required this.dateFrom,
    required this.dateTo,
    required this.timesheetStatus,
    required this.timesheetElements,
  });
}
