import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_entity.dart';

abstract class TimesheetDayAppointmentsState {
  TimesheetDayAppointmentsState();
}

class TimesheetDayAppointmentsLoadingState
    extends TimesheetDayAppointmentsState {
  TimesheetDayAppointmentsLoadingState();
}

class TimesheetDayAppointmentsLoadedState
    extends TimesheetDayAppointmentsState {
  final List<DayAppointmentsEntity> appointments;
  TimesheetDayAppointmentsLoadedState({
    required this.appointments,
  });
}

class TimesheetDayAppointmentsFailedState
    extends TimesheetDayAppointmentsState {
  TimesheetDayAppointmentsFailedState() : super();
}
