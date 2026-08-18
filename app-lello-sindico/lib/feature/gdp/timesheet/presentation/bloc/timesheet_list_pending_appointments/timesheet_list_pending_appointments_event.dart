import 'package:essentials/functional/failure.dart';

abstract class TimesheetListPendingAppointmentsEvent {}

class TimesheetListPendingAppointmentsLoadingEvent
    extends TimesheetListPendingAppointmentsEvent {
  TimesheetListPendingAppointmentsLoadingEvent();
}

class TimesheetListPendingAppointmentsLoadedEvent
    extends TimesheetListPendingAppointmentsEvent {
  final List<String> appointments;
  TimesheetListPendingAppointmentsLoadedEvent({required this.appointments});
}

class TimesheetListPendingAppointmentsFailedEvent
    extends TimesheetListPendingAppointmentsEvent {
  final Failure err;
  TimesheetListPendingAppointmentsFailedEvent(this.err);
}
