import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_type_enum.dart';

class TimesheetFilter {
  String? name;
  String? id;
  TimesheetTypeEnum? type;
  DateTime? dobFrom;
  DateTime? dobTo;

  TimesheetFilter({this.name, this.id, this.type, this.dobFrom, this.dobTo});
}
