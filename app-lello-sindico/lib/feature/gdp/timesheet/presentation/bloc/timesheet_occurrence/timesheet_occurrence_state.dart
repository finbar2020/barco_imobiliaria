import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';

abstract class TimesheetOccurrenceState extends Equatable {
  const TimesheetOccurrenceState();

  @override
  List<Object?> get props => [];
}

class TimesheetOccurrenceLoadingState extends TimesheetOccurrenceState {
  const TimesheetOccurrenceLoadingState();
}

class TimesheetOccurrenceLoadedState extends TimesheetOccurrenceState {
  final List<TimesheetOccurrenceEntity> list;
  final bool saveSuccess;
  final bool saveFailed;
  final String? employeeFiltered;
  final String? typeFiltered;

  const TimesheetOccurrenceLoadedState({
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

class TimesheetOccurrenceFailedState extends TimesheetOccurrenceState {
  const TimesheetOccurrenceFailedState();
}
