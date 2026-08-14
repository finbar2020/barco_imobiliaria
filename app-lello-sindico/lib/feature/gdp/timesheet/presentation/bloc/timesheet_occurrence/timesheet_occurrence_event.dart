import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';

abstract class TimesheetOccurrenceEvent extends Equatable {
  const TimesheetOccurrenceEvent();

  @override
  List<Object?> get props => [];
}

class TimesheetOccurrenceLoadingEvent extends TimesheetOccurrenceEvent {
  const TimesheetOccurrenceLoadingEvent();
}

class TimesheetOccurrenceLoadedEvent extends TimesheetOccurrenceEvent {
  final List<TimesheetOccurrenceEntity> list;
  final bool saveSuccess;
  final bool saveFailed;
  final String? employeeFiltered;
  final String? typeFiltered;

  const TimesheetOccurrenceLoadedEvent({
    required this.list,
    this.saveSuccess = false,
    this.saveFailed = false,
    this.employeeFiltered,
    this.typeFiltered,
  });

  @override
  List<Object?> get props =>
      [list, saveSuccess, saveFailed, employeeFiltered, typeFiltered];
}

class TimesheetOccurrenceFailedEvent extends TimesheetOccurrenceEvent {
  const TimesheetOccurrenceFailedEvent();
}
