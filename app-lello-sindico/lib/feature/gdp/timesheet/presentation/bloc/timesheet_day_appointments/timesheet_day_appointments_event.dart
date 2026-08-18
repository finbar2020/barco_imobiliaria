import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_entity.dart';

abstract class TimesheetDayAppointmentsEvent {}

class DayAppointmentsLoadingEvent extends TimesheetDayAppointmentsEvent {
  DayAppointmentsLoadingEvent();
}

class DayAppointmentsLoadedEvent extends TimesheetDayAppointmentsEvent {
  final List<DayAppointmentsEntity> appointments;
  DayAppointmentsLoadedEvent({required this.appointments});
}

class DayAppointmentsFailedEvent extends TimesheetDayAppointmentsEvent {
  DayAppointmentsFailedEvent();
}
