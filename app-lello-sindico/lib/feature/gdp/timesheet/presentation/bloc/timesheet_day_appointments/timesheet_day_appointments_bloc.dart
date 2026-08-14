import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_day_appointments/timesheet_day_appointments_event.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_day_appointments/timesheet_day_appointments_state.dart';

class TimesheetDayAppointmentsBloc
    extends Bloc<TimesheetDayAppointmentsEvent, TimesheetDayAppointmentsState> {
  TimesheetDayAppointmentsBloc()
      : super(TimesheetDayAppointmentsLoadingState()) {
    on<DayAppointmentsLoadingEvent>(handleLoadingEvent);
    on<DayAppointmentsLoadedEvent>(handleLoadedEvent);
    on<DayAppointmentsFailedEvent>(handleFailedEvent);
  }

  void handleLoadingEvent(DayAppointmentsLoadingEvent event, Emitter emit) {
    emit(TimesheetDayAppointmentsLoadingState());
  }

  void handleLoadedEvent(DayAppointmentsLoadedEvent event, Emitter emit) {
    emit(TimesheetDayAppointmentsLoadedState(appointments: event.appointments));
  }

  void handleFailedEvent(DayAppointmentsFailedEvent event, Emitter emit) {
    emit(TimesheetDayAppointmentsFailedState());
  }
}
