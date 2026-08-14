import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/feature/gdp/data/model/employee_model.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation.dart';

part 'vacation_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class VacationModel {
  EmployeeModel? employee;
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
  List<VacationModel>? scheduledVacations;

  VacationModel(
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
      this.deadLine,
      this.allowanceDays = 0.0,
      this.numberAbsences = 0.0,
      this.vacationStartDate,
      this.vacationEndDate,
      this.scheduledDays = 0,
      this.salaryAllowance = 0,
      this.advance13 = "",
      this.totalVacation = 0,
      this.numbersUnitVacation = 0,
      this.scheduledVacations});

  factory VacationModel.fromJson(Map<String, dynamic> json) =>
      _$VacationModelFromJson(json);

  Map<String, dynamic> toJson() => _$VacationModelToJson(this);

  static VacationModel? fromEntity(Vacation? entity) => entity == null
      ? null
      : (VacationModel()
        ..employee = EmployeeModel.fromEntity(entity.employee)
        ..company = entity.company
        ..employeeId = entity.employeeId
        ..employeeType = entity.employeeType
        ..employeeRegistrationNumber = entity.employeeRegistrationNumber
        ..acquisitivePeriodStartDate = entity.acquisitivePeriodStartDate
        ..acquisitivePeriodEndDate = entity.acquisitivePeriodEndDate
        ..reference = entity.reference
        ..employeeName = entity.employeeName
        ..admissionDate = entity.admissionDate
        ..deadLine = entity.deadLine
        ..allowanceDays = entity.allowanceDays
        ..numberAbsences = entity.numberAbsences
        ..vacationStartDate = entity.vacationStartDate
        ..vacationEndDate = entity.vacationEndDate
        ..scheduledDays = entity.scheduledDays
        ..salaryAllowance = entity.salaryAllowance
        ..advance13 = entity.advance13
        ..totalVacation = entity.totalVacation
        ..numbersUnitVacation = entity.numbersUnitVacation);

  Vacation toEntity() => Vacation()
    ..employee = employee?.toEntity()
    ..employeeId = employeeId
    ..company = company
    ..employeeType = employeeType
    ..employeeRegistrationNumber = employeeRegistrationNumber
    ..acquisitivePeriodStartDate = acquisitivePeriodStartDate
    ..acquisitivePeriodEndDate = acquisitivePeriodEndDate
    ..reference = reference
    ..employeeName = employeeName
    ..admissionDate = admissionDate
    ..deadLine = deadLine
    ..allowanceDays = allowanceDays
    ..numberAbsences = numberAbsences
    ..vacationStartDate = vacationStartDate
    ..vacationEndDate = vacationEndDate
    ..scheduledDays = scheduledDays
    ..salaryAllowance = salaryAllowance
    ..advance13 = advance13
    ..totalVacation = totalVacation
    ..numbersUnitVacation = numbersUnitVacation
    ..scheduledVacations =
        scheduledVacations?.map((e) => e.toEntity()).toList();

  map(Function(dynamic model) param0) {}
}
