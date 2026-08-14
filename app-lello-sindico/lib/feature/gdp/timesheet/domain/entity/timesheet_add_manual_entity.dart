import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_add_manual_enum.dart';

class TimesheetAddManualEntity {
  final String numCra;
  final DateTime date;
  final TimesheetAddManualEnum type;
  final String justification;
  final List<String> marks;
  final bool single;
  TimesheetAddManualEntity({
    required this.numCra,
    required this.date,
    required this.type,
    required this.justification,
    required this.marks,
    required this.single,
  });
}
