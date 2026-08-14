import 'package:essentials/essentials.dart';

abstract class TimesheetMenuEvent extends Equatable {
  const TimesheetMenuEvent();

  @override
  List<Object?> get props => [];
}

class TimesheetMenuLoadEvent extends TimesheetMenuEvent {
  final String? condominiumId;

  const TimesheetMenuLoadEvent({this.condominiumId});

  @override
  List<Object?> get props => [condominiumId];
}

class TimesheetRequestEvent extends TimesheetMenuEvent {
  final String? condominiumId;

  const TimesheetRequestEvent({this.condominiumId});

  @override
  List<Object?> get props => [condominiumId];
}

class TimesheetGetMonthResumeEvent extends TimesheetMenuEvent {
  final DateTime date;

  const TimesheetGetMonthResumeEvent({required this.date});

  @override
  List<Object?> get props => [date];
}

class TimesheetGetPeriodsEvent extends TimesheetMenuEvent {
  const TimesheetGetPeriodsEvent();
}
