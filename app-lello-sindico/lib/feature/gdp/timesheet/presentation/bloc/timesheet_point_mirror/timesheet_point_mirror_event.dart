import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_entity.dart';

abstract class TimesheetPointMirrorEvent {}

class TimesheetPointMirrorLoadingEvent extends TimesheetPointMirrorEvent {
  TimesheetPointMirrorLoadingEvent();
}

class TimesheetPointMirrorLoadedEvent extends TimesheetPointMirrorEvent {
  final List<TimesheetEntity> list;
  final bool saveSuccess;
  final bool saveFailed;
  TimesheetPointMirrorLoadedEvent({
    required this.list,
    this.saveSuccess = false,
    this.saveFailed = false,
  });
}

class TimesheetPointMirrorFailedEvent extends TimesheetPointMirrorEvent {
  TimesheetPointMirrorFailedEvent();
}
