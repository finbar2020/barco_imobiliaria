import 'package:lello/feature/gdp/vacation/domain/entity/vacation_created.dart';

abstract class ScheduleVacationEvent {}
class CreateScheduledVacationEvent extends ScheduleVacationEvent {
  final String employeeId;
  final VacationCreated vacationCreated;

  CreateScheduledVacationEvent({
    required this.employeeId,
    required this.vacationCreated,
  });
}
