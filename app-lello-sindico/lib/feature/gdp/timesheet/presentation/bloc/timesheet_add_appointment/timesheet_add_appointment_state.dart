abstract class TimesheetAddAppointmentState {
  TimesheetAddAppointmentState();
}

class TimesheetAddAppointmentInitialState extends TimesheetAddAppointmentState {
  TimesheetAddAppointmentInitialState();
}

class TimesheetAddAppointmentLoadingState extends TimesheetAddAppointmentState {
  TimesheetAddAppointmentLoadingState();
}

class TimesheetAddAppointmentSuccessState extends TimesheetAddAppointmentState {
  TimesheetAddAppointmentSuccessState();
}

class TimesheetAddAppointmentFailedState extends TimesheetAddAppointmentState {
  String? message;
  TimesheetAddAppointmentFailedState({this.message}) : super();
}
