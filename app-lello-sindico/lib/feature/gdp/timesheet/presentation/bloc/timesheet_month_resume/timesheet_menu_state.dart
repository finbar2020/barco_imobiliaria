import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_month_resume_entity.dart';

abstract class TimesheetMenuState extends Equatable {
  const TimesheetMenuState();

  @override
  List<Object?> get props => [];
}

class TimesheetLoadingState extends TimesheetMenuState {
  const TimesheetLoadingState();
}

class TimesheetFailedState extends TimesheetMenuState {
  const TimesheetFailedState();
}

class TimesheetLoadedState extends TimesheetMenuState {
  const TimesheetLoadedState();
}

class TimesheetMonthResumeLoadingState extends TimesheetLoadedState {
  const TimesheetMonthResumeLoadingState();
}

class TimesheetMonthResumeLoadedState extends TimesheetLoadedState {
  final TimesheetMonthResumeEntity entity;
  final DateTime date;

  const TimesheetMonthResumeLoadedState({
    required this.entity,
    required this.date,
  });

  @override
  List<Object?> get props => [entity, date];
}

class TimesheetMonthResumeFailedState extends TimesheetMenuState {
  const TimesheetMonthResumeFailedState();
}
