import 'package:essentials/essentials.dart';

abstract class TimesheetDetailEvent extends Equatable {
  const TimesheetDetailEvent();

  @override
  List<Object?> get props => [];
}

class GetTimesheetDetailEvent extends TimesheetDetailEvent {
  final DateTime period;
  const GetTimesheetDetailEvent(this.period);

  @override
  List<Object?> get props => [period];
}
