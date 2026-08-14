import 'package:lello/feature/gdp/vacation/domain/entity/vacation_scheduled_periods.dart';

class VacationCreated {
  String? employeeId;
  int? company;
  String? employeeRegistrationNumber;
  List<VacationScheduledPeriods?> vacationScheduledPeriods;
  int? salaryAllowance;
  String? advance13;
  int? numbersUnitVacation;

  VacationCreated(
      {this.employeeId,
      this.company,
      this.employeeRegistrationNumber,
      this.vacationScheduledPeriods = const [],
      this.salaryAllowance = 0,
      this.advance13 = "",
      this.numbersUnitVacation = 0});
}
