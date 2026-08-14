import 'package:essentials/essentials.dart';

abstract class TimesheetEmailEvent extends Equatable {
  const TimesheetEmailEvent();

  @override
  List<Object?> get props => [];
}

class SendEmailEvent extends TimesheetEmailEvent {
  final String email;
  final DateTime period;
  const SendEmailEvent(this.email, this.period);

  @override
  List<Object?> get props => [email, period];
}

class TryAgainEvent extends TimesheetEmailEvent {
  final String? email;
  final DateTime period;
  const TryAgainEvent({this.email, required this.period});

  @override
  List<Object?> get props => [email, period];
}
