import 'package:essentials/essentials.dart';

abstract class TimesheetSignEvent extends Equatable {
  const TimesheetSignEvent();

  @override
  List<Object?> get props => [];
}

class SignEvent extends TimesheetSignEvent {
  final DateTime period;
  const SignEvent(this.period);

  @override
  List<Object?> get props => [period];
}
