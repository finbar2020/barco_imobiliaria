abstract class TimesheetMenuEvent {}

class TimesheetMenuLoadEvent extends TimesheetMenuEvent {
  final String? condominiumId;
  TimesheetMenuLoadEvent({this.condominiumId});
}

class TimesheetRequestEvent extends TimesheetMenuEvent {
  final String? condominiumId;
  TimesheetRequestEvent({this.condominiumId});
}

class TimesheetGetMonthResumeEvent extends TimesheetMenuEvent {
  final DateTime date;
  TimesheetGetMonthResumeEvent({required this.date});
}

class TimesheetGetPeriodsEvent extends TimesheetMenuEvent {
  TimesheetGetPeriodsEvent();
}
