import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/gdp/vacation/data/model/vacation_scheduled_periods_model.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation_created.dart';

part 'vacation_created_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class VacationCreatedModel {
  String? employeeId;
  int? company;
  String? employeeRegistrationNumber;
  List<VacationScheduledPeriodsModel?> vacationScheduledPeriods;
  int? salaryAllowance;
  String? advance13;
  int? numbersUnitVacation;

  VacationCreatedModel(
      {this.employeeId,
      this.company,
      this.employeeRegistrationNumber,
      this.vacationScheduledPeriods = const [],
      this.salaryAllowance = 0,
      this.advance13 = "",
      this.numbersUnitVacation = 0});

  factory VacationCreatedModel.fromJson(Map<String, dynamic> json) =>
      _$VacationCreatedModelFromJson(json);

  Map<String, dynamic> toJson() => _$VacationCreatedModelToJson(this);

  static VacationCreatedModel? fromEntity(VacationCreated? entity) =>
      entity == null
          ? null
          : (VacationCreatedModel()
            ..employeeId = entity.employeeId
            ..company = entity.company
            ..employeeRegistrationNumber = entity.employeeRegistrationNumber
            ..vacationScheduledPeriods = entity.vacationScheduledPeriods.isEmpty
                ? []
                : entity.vacationScheduledPeriods
                    .map((e) => VacationScheduledPeriodsModel.fromEntity(e))
                    .toList()
            ..salaryAllowance = entity.salaryAllowance
            ..advance13 = entity.advance13
            ..numbersUnitVacation = entity.numbersUnitVacation);

  VacationCreated toEntity() => VacationCreated(
        employeeId: this.employeeId,
        company: this.company,
        employeeRegistrationNumber: this.employeeRegistrationNumber,
        vacationScheduledPeriods: this.vacationScheduledPeriods.isEmpty
            ? []
            : this.vacationScheduledPeriods.map((e) => e?.toEntity()).toList(),
        salaryAllowance: this.salaryAllowance,
        advance13: this.advance13,
        numbersUnitVacation: this.numbersUnitVacation,
      );
}
