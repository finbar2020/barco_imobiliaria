import 'package:essentials/functional/failure.dart';

abstract class TimesheetListPendingAppointmentState {
  TimesheetListPendingAppointmentState();
}

class TimesheetListPendingAppointmentLoadingState
    extends TimesheetListPendingAppointmentState {
  TimesheetListPendingAppointmentLoadingState();
}

class TimesheetListPendingAppointmentLoadedState
    extends TimesheetListPendingAppointmentState {
  final List<String> appointments;
  TimesheetListPendingAppointmentLoadedState({
    required this.appointments,
  });
}

class TimesheetListPendingAppointmentFailedState
    extends TimesheetListPendingAppointmentState {
  final Failure err;
  TimesheetListPendingAppointmentFailedState(this.err) : super();
}
