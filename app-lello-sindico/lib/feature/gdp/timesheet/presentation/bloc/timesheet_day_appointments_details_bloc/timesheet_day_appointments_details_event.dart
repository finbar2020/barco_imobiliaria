import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_check_in_data_entity.dart';

abstract class TimesheetDayAppointmentsDetailsEvent {}

class TimesheetDayAppointmentsDetailsLoadingEvent
    extends TimesheetDayAppointmentsDetailsEvent {
  TimesheetDayAppointmentsDetailsLoadingEvent();
}

class TimesheetDayAppointmentsDetailsLoadedEvent
    extends TimesheetDayAppointmentsDetailsEvent {
  List<TimesheetDayAppointmentsCheckInData> details;
  TimesheetDayAppointmentsDetailsLoadedEvent({required this.details});
}

class TimesheetDayAppointmentsDetailsFailedEvent
    extends TimesheetDayAppointmentsDetailsEvent {
  TimesheetDayAppointmentsDetailsFailedEvent();
}
