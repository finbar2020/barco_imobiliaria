import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_vacation_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';

abstract class DetailsListEvent extends Equatable {
  const DetailsListEvent();

  @override
  List<Object?> get props => [];
}

class DetailsListLoadingEvent extends DetailsListEvent {
  const DetailsListLoadingEvent();
}

class DetailsListLoadedEvent extends DetailsListEvent {
  final List<TimesheetOccurrenceEntity> list;
  final bool saveSuccess;
  final bool saveFailed;

  const DetailsListLoadedEvent({
    required this.list,
    this.saveSuccess = false,
    this.saveFailed = false,
  });

  @override
  List<Object?> get props => [list, saveSuccess, saveFailed];
}

class VacationsListLoadedEvent extends DetailsListEvent {
  final List<TimesheetOccurrenceVacationEntity> list;
  final bool getArchiveFailed;
  final File? pdf;
  final String? filename;

  const VacationsListLoadedEvent({
    required this.list,
    this.getArchiveFailed = false,
    this.pdf,
    this.filename,
  });

  @override
  List<Object?> get props => [list, getArchiveFailed, pdf, filename];
}

class DetailsListFailedEvent extends DetailsListEvent {
  const DetailsListFailedEvent();
}
