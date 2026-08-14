import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation_created.dart';

abstract class ScheduleVacation
    extends UseCase<VacationCreated, ScheduleVacationParam> {}

class ScheduleVacationParam {
  final String condominiumId;
  final String employeeId;
  final VacationCreated vacationCreated;

  ScheduleVacationParam({
    required this.condominiumId,
    required this.employeeId,
    required this.vacationCreated,
  });
}
