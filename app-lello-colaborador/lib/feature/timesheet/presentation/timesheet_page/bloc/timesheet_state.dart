import 'package:colaborador/feature/timesheet/domain/entity/timesheet.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_periods.dart';
import 'package:essentials/essentials.dart';

abstract class TimesheetState extends Equatable {
  const TimesheetState();

  @override
  List<Object?> get props => [];
}

class TimesheetInitialState extends TimesheetState {
  const TimesheetInitialState();
}

class TimesheetLoadingState extends TimesheetState {
  const TimesheetLoadingState();
}

class TimesheetPeriodsLoadingState extends TimesheetState {
  const TimesheetPeriodsLoadingState();
}

class TimesheetLoadedState extends TimesheetState {
  final Timesheet timesheet;

  const TimesheetLoadedState({
    required this.timesheet,
  });

  @override
  List<Object?> get props => [timesheet];
}

class TimesheetPeriodsLoadedState extends TimesheetState {
  final List<TimesheetPeriods> timesheetPeriods;

  const TimesheetPeriodsLoadedState({
    required this.timesheetPeriods,
  });

  @override
  List<Object?> get props => [timesheetPeriods];
}

class TimesheetFailedState extends TimesheetState {
  const TimesheetFailedState();
}

class TimesheetPeriodsEmptyState extends TimesheetState {
  const TimesheetPeriodsEmptyState();
}

class TimesheetPeriodsFailedState extends TimesheetState {
  final String errorDescription;
  final String errorCode;

  const TimesheetPeriodsFailedState(
      {required this.errorDescription, required this.errorCode});

  @override
  List<Object?> get props => [errorDescription, errorCode];
}
