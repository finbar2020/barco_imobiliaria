import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_month_resume_entity.dart';

abstract class TimesheetMenuState {
  TimesheetMenuState();
}

class TimesheetLoadingState extends TimesheetMenuState {
  TimesheetLoadingState();
}

class TimesheetFailedState extends TimesheetMenuState {
  TimesheetFailedState();
}

class TimesheetLoadedState extends TimesheetMenuState {
  TimesheetLoadedState();
}

class TimesheetMonthResumeLoadingState extends TimesheetLoadedState {
  TimesheetMonthResumeLoadingState();
}

class TimesheetMonthResumeLoadedState extends TimesheetLoadedState {
  final TimesheetMonthResumeEntity entity;
  final DateTime date;
  TimesheetMonthResumeLoadedState({
    required this.entity,
    required this.date,
  });
}

class TimesheetMonthResumeFailedState extends TimesheetMenuState {
  TimesheetMonthResumeFailedState() : super();
}
