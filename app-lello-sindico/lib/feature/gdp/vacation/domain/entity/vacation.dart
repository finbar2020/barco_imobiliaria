import 'package:lello/feature/gdp/domain/entity/employee.dart';

class Vacation {
  Employee? employee;
  String? employeeId;
  int? company;
  int? employeeType;
  String? employeeRegistrationNumber;
  String? acquisitivePeriodStartDate;
  String? acquisitivePeriodEndDate;
  String? reference;
  String? employeeName;
  String? admissionDate;
  String? deadLine;
  double? allowanceDays;
  double? numberAbsences;
  String? vacationStartDate;
  String? vacationEndDate;
  int? scheduledDays;
  int? salaryAllowance;
  String? advance13;
  int? totalVacation;
  int? numbersUnitVacation;

  List<Vacation>? scheduledVacations;

  Vacation(
      {this.employee,
      this.employeeId,
      this.company,
      this.employeeType,
      this.employeeRegistrationNumber,
      this.acquisitivePeriodStartDate,
      this.acquisitivePeriodEndDate,
      this.reference,
      this.employeeName,
      this.admissionDate,
      this.deadLine = "",
      this.allowanceDays = 0.0,
      this.numberAbsences = 0.0,
      this.vacationStartDate,
      this.vacationEndDate,
      this.scheduledDays = 0,
      this.salaryAllowance = 0,
      this.advance13 = "",
      this.totalVacation = 0,
      this.numbersUnitVacation = 0});

  String get getAdvance13 {
    var result;
    if (advance13 == "S") {
      result = "yes";
    } else {
      result = "no";
    }
    return result;
  }

  int? get getNumbersUnitVacation {
    int? result = 0;
    if (numbersUnitVacation != 0) {
      result = numbersUnitVacation!;
    } else {
      result = null;
    }
    return result;
  }

  List<String> get getScheduledDays {
    int? result = 0;
    if (scheduledDays != 0) {
      result = scheduledDays!;
    }
    return result.toString().split("d");
  }

  String get getPeriodVacation {
    var startDate = (acquisitivePeriodStartDate).toString();
    var endDate = (acquisitivePeriodEndDate).toString();
    return "$startDate a $endDate ";
  }
}
