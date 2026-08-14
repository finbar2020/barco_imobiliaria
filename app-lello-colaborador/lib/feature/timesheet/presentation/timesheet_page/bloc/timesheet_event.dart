import 'package:essentials/essentials.dart';

abstract class TimesheetEvent extends Equatable {
  const TimesheetEvent();

  @override
  List<Object?> get props => [];
}

class GetTimesheetEvent extends TimesheetEvent {
  final DateTime period;
  const GetTimesheetEvent(this.period);

  @override
  List<Object?> get props => [period];
}

class GetTimesheetPeriodsEvent extends TimesheetEvent {
  const GetTimesheetPeriodsEvent();
}
