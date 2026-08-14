import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_list_pending_appointments/timesheet_list_pending_appointments_event.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_list_pending_appointments/timesheet_list_pending_appointments_state.dart';

class TimesheetListPendingAppointmentsBloc extends Bloc<
    TimesheetListPendingAppointmentsEvent,
    TimesheetListPendingAppointmentState> {
  TimesheetListPendingAppointmentsBloc()
      : super(TimesheetListPendingAppointmentLoadingState()) {
    on<TimesheetListPendingAppointmentsLoadingEvent>(handleLoadingEvent);
    on<TimesheetListPendingAppointmentsLoadedEvent>(handleLoadedEvent);
    on<TimesheetListPendingAppointmentsFailedEvent>(handleFailedEvent);
  }

  void handleLoadingEvent(
      TimesheetListPendingAppointmentsLoadingEvent event, Emitter emit) {
    emit(TimesheetListPendingAppointmentLoadingState());
  }

  void handleLoadedEvent(
      TimesheetListPendingAppointmentsLoadedEvent event, Emitter emit) {
    emit(TimesheetListPendingAppointmentLoadedState(
        appointments: event.appointments));
  }

  void handleFailedEvent(
      TimesheetListPendingAppointmentsFailedEvent event, Emitter emit) {
    emit(TimesheetListPendingAppointmentFailedState(event.err));
  }
}
