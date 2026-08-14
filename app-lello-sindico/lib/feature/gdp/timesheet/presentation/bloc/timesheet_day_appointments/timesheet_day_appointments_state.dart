import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_entity.dart';

abstract class TimesheetDayAppointmentsState extends Equatable {
  const TimesheetDayAppointmentsState();

  @override
  List<Object?> get props => [];
}

class TimesheetDayAppointmentsLoadingState
    extends TimesheetDayAppointmentsState {
  const TimesheetDayAppointmentsLoadingState();
}

class TimesheetDayAppointmentsLoadedState
    extends TimesheetDayAppointmentsState {
  final List<DayAppointmentsEntity> appointments;

  const TimesheetDayAppointmentsLoadedState({
    required this.appointments,
  });

  @override
  List<Object?> get props => [appointments];
}

class TimesheetDayAppointmentsFailedState
    extends TimesheetDayAppointmentsState {
  const TimesheetDayAppointmentsFailedState();
}
