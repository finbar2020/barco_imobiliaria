import 'package:essentials/essentials.dart';

abstract class TimesheetListPendingAppointmentsEvent extends Equatable {
  const TimesheetListPendingAppointmentsEvent();

  @override
  List<Object?> get props => [];
}

class TimesheetListPendingAppointmentsLoadingEvent
    extends TimesheetListPendingAppointmentsEvent {
  const TimesheetListPendingAppointmentsLoadingEvent();
}

class TimesheetListPendingAppointmentsLoadedEvent
    extends TimesheetListPendingAppointmentsEvent {
  final List<String> appointments;

  const TimesheetListPendingAppointmentsLoadedEvent({
    required this.appointments,
  });

  @override
  List<Object?> get props => [appointments];
}

class TimesheetListPendingAppointmentsFailedEvent
    extends TimesheetListPendingAppointmentsEvent {
  final Failure err;

  const TimesheetListPendingAppointmentsFailedEvent(this.err);

  @override
  List<Object?> get props => [err];
}
