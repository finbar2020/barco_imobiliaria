import 'package:essentials/essentials.dart';

abstract class TimesheetAddAppointmentEvent extends Equatable {
  const TimesheetAddAppointmentEvent();

  @override
  List<Object?> get props => [];
}

class TimesheetAddAppointmentLoadingEvent extends TimesheetAddAppointmentEvent {
  const TimesheetAddAppointmentLoadingEvent();
}

class TimesheetAddAppointmentSuccessEvent extends TimesheetAddAppointmentEvent {
  const TimesheetAddAppointmentSuccessEvent();
}

class TimesheetAddAppointmentFailedEvent extends TimesheetAddAppointmentEvent {
  final String? message;

  const TimesheetAddAppointmentFailedEvent({this.message});

  @override
  List<Object?> get props => [message];
}
