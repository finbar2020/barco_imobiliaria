abstract class TimesheetAddAppointmentEvent {}

class TimesheetAddAppointmentLoadingEvent extends TimesheetAddAppointmentEvent {
  TimesheetAddAppointmentLoadingEvent();
}

class TimesheetAddAppointmentSuccessEvent extends TimesheetAddAppointmentEvent {
  TimesheetAddAppointmentSuccessEvent();
}

class TimesheetAddAppointmentFailedEvent extends TimesheetAddAppointmentEvent {
  String? message;
  TimesheetAddAppointmentFailedEvent({this.message});
}
