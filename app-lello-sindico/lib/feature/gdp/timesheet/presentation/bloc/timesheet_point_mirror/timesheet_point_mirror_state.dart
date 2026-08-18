import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_entity.dart';

abstract class TimesheetPointMirrorState {
  TimesheetPointMirrorState();
}

class TimesheetPointMirrorLoadingState extends TimesheetPointMirrorState {
  TimesheetPointMirrorLoadingState();
}

class TimesheetPointMirrorLoadedState extends TimesheetPointMirrorState {
  final List<TimesheetEntity> list;
  final bool saveSuccess;
  final bool saveFailed;
  TimesheetPointMirrorLoadedState({
    required this.list,
    this.saveSuccess = false,
    this.saveFailed = false,
  });
}

class TimesheetPointMirrorFailedState extends TimesheetPointMirrorState {
  TimesheetPointMirrorFailedState() : super();
}
