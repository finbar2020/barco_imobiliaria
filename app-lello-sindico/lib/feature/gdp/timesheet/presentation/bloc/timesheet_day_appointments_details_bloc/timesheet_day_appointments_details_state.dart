import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_check_in_data_entity.dart';

abstract class TimesheetDayAppointmentsDetailsState extends Equatable {
  const TimesheetDayAppointmentsDetailsState();

  @override
  List<Object?> get props => [];
}

class TimesheetDayAppointmentsDetailsLoadingState
    extends TimesheetDayAppointmentsDetailsState {
  const TimesheetDayAppointmentsDetailsLoadingState();
}

class TimesheetDayAppointmentsDetailsLoadedState
    extends TimesheetDayAppointmentsDetailsState {
  final List<TimesheetDayAppointmentsCheckInData> details;

  const TimesheetDayAppointmentsDetailsLoadedState({required this.details});

  @override
  List<Object?> get props => [details];
}

class TimesheetDayAppointmentsDetailsFailedState
    extends TimesheetDayAppointmentsDetailsState {
  const TimesheetDayAppointmentsDetailsFailedState();
}
