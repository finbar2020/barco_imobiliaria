import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';

abstract class TimesheetOccurrenceEvent {}

class TimesheetOccurrenceLoadingEvent extends TimesheetOccurrenceEvent {
  TimesheetOccurrenceLoadingEvent();
}

class TimesheetOccurrenceLoadedEvent extends TimesheetOccurrenceEvent {
  final List<TimesheetOccurrenceEntity> list;
  final bool saveSuccess;
  final bool saveFailed;
  final String? employeeFiltered;
  final String? typeFiltered;
  TimesheetOccurrenceLoadedEvent({
    required this.list,
    this.saveSuccess = false,
    this.saveFailed = false,
    this.employeeFiltered,
    this.typeFiltered,
  });
}

class TimesheetOccurrenceFailedEvent extends TimesheetOccurrenceEvent {
  TimesheetOccurrenceFailedEvent();
}
