import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_add_appointment/timesheet_add_appointment_event.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_add_appointment/timesheet_add_appointment_state.dart';

class TimesheetAddAppointmentBloc
    extends Bloc<TimesheetAddAppointmentEvent, TimesheetAddAppointmentState> {
  TimesheetAddAppointmentBloc() : super(TimesheetAddAppointmentInitialState()) {
    on<TimesheetAddAppointmentLoadingEvent>(handleLoadingEvent);
    on<TimesheetAddAppointmentSuccessEvent>(handleSuccessEvent);
    on<TimesheetAddAppointmentFailedEvent>(handleFailedEvent);
  }

  void handleLoadingEvent(
      TimesheetAddAppointmentLoadingEvent event, Emitter emit) {
    emit(TimesheetAddAppointmentLoadingState());
  }

  void handleSuccessEvent(
      TimesheetAddAppointmentSuccessEvent event, Emitter emit) {
    emit(TimesheetAddAppointmentSuccessState());
  }

  void handleFailedEvent(
      TimesheetAddAppointmentFailedEvent event, Emitter emit) {
    emit(TimesheetAddAppointmentFailedState(message: event.message));
  }
}
