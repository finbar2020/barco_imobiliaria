import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_entity.dart';

abstract class TimesheetDayAppointmentsEvent extends Equatable {
  const TimesheetDayAppointmentsEvent();

  @override
  List<Object?> get props => [];
}

class DayAppointmentsLoadingEvent extends TimesheetDayAppointmentsEvent {
  const DayAppointmentsLoadingEvent();
}

class DayAppointmentsLoadedEvent extends TimesheetDayAppointmentsEvent {
  final List<DayAppointmentsEntity> appointments;

  const DayAppointmentsLoadedEvent({required this.appointments});

  @override
  List<Object?> get props => [appointments];
}

class DayAppointmentsFailedEvent extends TimesheetDayAppointmentsEvent {
  const DayAppointmentsFailedEvent();
}
