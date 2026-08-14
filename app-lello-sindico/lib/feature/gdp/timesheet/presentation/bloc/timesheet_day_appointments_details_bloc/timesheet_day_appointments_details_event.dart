import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_check_in_data_entity.dart';

abstract class TimesheetDayAppointmentsDetailsEvent extends Equatable {
  const TimesheetDayAppointmentsDetailsEvent();

  @override
  List<Object?> get props => [];
}

class TimesheetDayAppointmentsDetailsLoadingEvent
    extends TimesheetDayAppointmentsDetailsEvent {
  const TimesheetDayAppointmentsDetailsLoadingEvent();
}

class TimesheetDayAppointmentsDetailsLoadedEvent
    extends TimesheetDayAppointmentsDetailsEvent {
  final List<TimesheetDayAppointmentsCheckInData> details;

  const TimesheetDayAppointmentsDetailsLoadedEvent({required this.details});

  @override
  List<Object?> get props => [details];
}

class TimesheetDayAppointmentsDetailsFailedEvent
    extends TimesheetDayAppointmentsDetailsEvent {
  const TimesheetDayAppointmentsDetailsFailedEvent();
}
