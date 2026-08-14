import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_day_appointments_details_bloc/timesheet_day_appointments_details_event.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_day_appointments_details_bloc/timesheet_day_appointments_details_state.dart';

class TimesheetDayAppointmentsDetailsBloc extends Bloc<
    TimesheetDayAppointmentsDetailsEvent,
    TimesheetDayAppointmentsDetailsState> {
  TimesheetDayAppointmentsDetailsBloc()
      : super(TimesheetDayAppointmentsDetailsLoadingState()) {
    on<TimesheetDayAppointmentsDetailsLoadingEvent>(handleLoadingEvent);
    on<TimesheetDayAppointmentsDetailsLoadedEvent>(handleLoadedEvent);
    on<TimesheetDayAppointmentsDetailsFailedEvent>(handleFailedEvent);
  }

  void handleLoadingEvent(
      TimesheetDayAppointmentsDetailsLoadingEvent event, Emitter emit) {
    emit(TimesheetDayAppointmentsDetailsLoadingState());
  }

  void handleLoadedEvent(
      TimesheetDayAppointmentsDetailsLoadedEvent event, Emitter emit) {
    emit(TimesheetDayAppointmentsDetailsLoadedState(details: event.details));
  }

  void handleFailedEvent(
      TimesheetDayAppointmentsDetailsFailedEvent event, Emitter emit) {
    emit(TimesheetDayAppointmentsDetailsFailedState());
  }
}
