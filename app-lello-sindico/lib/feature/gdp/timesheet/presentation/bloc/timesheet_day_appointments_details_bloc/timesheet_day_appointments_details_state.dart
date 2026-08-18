import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_check_in_data_entity.dart';

abstract class TimesheetDayAppointmentsDetailsState {
  TimesheetDayAppointmentsDetailsState();
}

class TimesheetDayAppointmentsDetailsLoadingState
    extends TimesheetDayAppointmentsDetailsState {
  TimesheetDayAppointmentsDetailsLoadingState();
}

class TimesheetDayAppointmentsDetailsLoadedState
    extends TimesheetDayAppointmentsDetailsState {
  List<TimesheetDayAppointmentsCheckInData> details;
  TimesheetDayAppointmentsDetailsLoadedState({required this.details});
}

class TimesheetDayAppointmentsDetailsFailedState
    extends TimesheetDayAppointmentsDetailsState {
  TimesheetDayAppointmentsDetailsFailedState() : super();
}
