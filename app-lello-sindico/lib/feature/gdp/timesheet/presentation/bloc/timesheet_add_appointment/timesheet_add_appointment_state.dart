import 'package:essentials/essentials.dart';

abstract class TimesheetAddAppointmentState extends Equatable {
  const TimesheetAddAppointmentState();

  @override
  List<Object?> get props => [];
}

class TimesheetAddAppointmentInitialState extends TimesheetAddAppointmentState {
  const TimesheetAddAppointmentInitialState();
}

class TimesheetAddAppointmentLoadingState extends TimesheetAddAppointmentState {
  const TimesheetAddAppointmentLoadingState();
}

class TimesheetAddAppointmentSuccessState extends TimesheetAddAppointmentState {
  const TimesheetAddAppointmentSuccessState();
}

class TimesheetAddAppointmentFailedState extends TimesheetAddAppointmentState {
  final String? message;

  const TimesheetAddAppointmentFailedState({this.message});

  @override
  List<Object?> get props => [message];
}
