import 'package:colaborador/feature/timesheet/domain/entity/timesheet_element_detail.dart';
import 'package:essentials/essentials.dart';

abstract class TimesheetDetailState extends Equatable {
  const TimesheetDetailState();

  @override
  List<Object?> get props => [];
}

class TimesheetDetailInitialState extends TimesheetDetailState {
  const TimesheetDetailInitialState();
}

class TimesheetDetailLoadingState extends TimesheetDetailState {
  const TimesheetDetailLoadingState();
}

class TimesheetDetailLoadedState extends TimesheetDetailState {
  final Map<DateTime, List<TimesheetElementDetail>> timesheetDetail;

  const TimesheetDetailLoadedState({
    required this.timesheetDetail,
  });

  @override
  List<Object?> get props => [timesheetDetail];
}

class TimesheetDetailFailedState extends TimesheetDetailState {
  final Failure? failure;

  const TimesheetDetailFailedState({required this.failure});

  @override
  List<Object?> get props => [failure];
}
