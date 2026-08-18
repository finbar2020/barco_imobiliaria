import 'dart:io';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_vacation_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';

abstract class TimesheetDetailsListState {
  TimesheetDetailsListState();
}

class TimesheetDetailsListLoadingState extends TimesheetDetailsListState {
  TimesheetDetailsListLoadingState();
}

class TimesheetDetailsListLoadedState extends TimesheetDetailsListState {
  final List<TimesheetOccurrenceEntity> list;
  final bool saveSuccess;
  final bool saveFailed;
  TimesheetDetailsListLoadedState({
    required this.list,
    this.saveSuccess = false,
    this.saveFailed = false,
  });
}

class TimesheetVacationsLoadedState extends TimesheetDetailsListState {
  final List<TimesheetOccurrenceVacationEntity> list;
  final bool getArchiveFailed;
  final File? pdf;
  final String? filename;
  TimesheetVacationsLoadedState({
    required this.list,
    this.getArchiveFailed = false,
    this.pdf,
    this.filename,
  });
}

class TimesheetDetailsListFailedState extends TimesheetDetailsListState {
  TimesheetDetailsListFailedState() : super();
}
