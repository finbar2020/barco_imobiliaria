import 'package:colaborador/feature/timesheet/domain/entity/timesheet_point_flag_enum.dart';

class TimesheetElementDetail {
  String time;
  TimesheetPointFlagEnum timesheetFlag;
  DateTime date;

  TimesheetElementDetail({
    required this.time,
    required this.timesheetFlag,
    required this.date,
  });
}
