import 'dart:io';

import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_vacation_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';

abstract class DetailsListEvent {}

class DetailsListLoadingEvent extends DetailsListEvent {
  DetailsListLoadingEvent();
}

class DetailsListLoadedEvent extends DetailsListEvent {
  final List<TimesheetOccurrenceEntity> list;
  final bool saveSuccess;
  final bool saveFailed;
  DetailsListLoadedEvent({
    required this.list,
    this.saveSuccess = false,
    this.saveFailed = false,
  });
}

class VacationsListLoadedEvent extends DetailsListEvent {
  final List<TimesheetOccurrenceVacationEntity> list;
  final bool getArchiveFailed;
  final File? pdf;
  final String? filename;
  VacationsListLoadedEvent({
    required this.list,
    this.getArchiveFailed = false,
    this.pdf,
    this.filename,
  });
}

class DetailsListFailedEvent extends DetailsListEvent {
  DetailsListFailedEvent();
}
