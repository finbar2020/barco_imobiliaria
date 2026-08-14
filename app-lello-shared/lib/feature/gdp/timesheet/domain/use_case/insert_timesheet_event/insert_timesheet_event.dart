import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_event.dart';

abstract class InsertTimesheetEvent
    extends UseCase<TimesheetEvent, InsertTimesheetEventParam> {}

class InsertTimesheetEventParam {
  final String condominiumId;
  final TimesheetEvent events;

  InsertTimesheetEventParam(
      {required this.condominiumId, required this.events});
}
