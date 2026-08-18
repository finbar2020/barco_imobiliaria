import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';

abstract class TimesheetOccurrenceState {
  TimesheetOccurrenceState();
}

class TimesheetOccurrenceLoadingState extends TimesheetOccurrenceState {
  TimesheetOccurrenceLoadingState();
}

class TimesheetOccurrenceLoadedState extends TimesheetOccurrenceState {
  final List<TimesheetOccurrenceEntity> list;
  final bool saveSuccess;
  final bool saveFailed;
  final String? employeeFiltered;
  final String? typeFiltered;
  TimesheetOccurrenceLoadedState({
    required this.list,
    this.saveSuccess = false,
    this.saveFailed = false,
    this.employeeFiltered,
    this.typeFiltered,
  });
}

class TimesheetOccurrenceFailedState extends TimesheetOccurrenceState {
  TimesheetOccurrenceFailedState() : super();
}
