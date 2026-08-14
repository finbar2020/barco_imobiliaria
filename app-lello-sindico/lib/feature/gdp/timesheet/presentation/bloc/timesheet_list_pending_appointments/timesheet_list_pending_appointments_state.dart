import 'package:essentials/essentials.dart';

abstract class TimesheetListPendingAppointmentState extends Equatable {
  const TimesheetListPendingAppointmentState();

  @override
  List<Object?> get props => [];
}

class TimesheetListPendingAppointmentLoadingState
    extends TimesheetListPendingAppointmentState {
  const TimesheetListPendingAppointmentLoadingState();
}

class TimesheetListPendingAppointmentLoadedState
    extends TimesheetListPendingAppointmentState {
  final List<String> appointments;

  const TimesheetListPendingAppointmentLoadedState({
    required this.appointments,
  });

  @override
  List<Object?> get props => [appointments];
}

class TimesheetListPendingAppointmentFailedState
    extends TimesheetListPendingAppointmentState {
  final Failure err;

  const TimesheetListPendingAppointmentFailedState(this.err);

  @override
  List<Object?> get props => [err];
}
