import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_created.dart';

abstract class ScheduleVacationEvent extends Equatable {
  const ScheduleVacationEvent();

  @override
  List<Object?> get props => [];
}

class CreateScheduledVacationEvent extends ScheduleVacationEvent {
  final String employeeId;
  final VacationCreated vacationCreated;

  const CreateScheduledVacationEvent({
    required this.employeeId,
    required this.vacationCreated,
  });

  @override
  List<Object?> get props => [employeeId, vacationCreated];
}
