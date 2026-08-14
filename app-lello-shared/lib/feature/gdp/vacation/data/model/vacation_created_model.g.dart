// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacation_created_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VacationCreatedModel _$VacationCreatedModelFromJson(
        Map<String, dynamic> json) =>
    VacationCreatedModel(
      employeeId: json['employee_id'] as String?,
      company: (json['company'] as num?)?.toInt(),
      employeeRegistrationNumber:
          json['employee_registration_number'] as String?,
      vacationScheduledPeriods:
          (json['vacation_scheduled_periods'] as List<dynamic>?)
                  ?.map((e) => e == null
                      ? null
                      : VacationScheduledPeriodsModel.fromJson(
                          e as Map<String, dynamic>))
                  .toList() ??
              const [],
      salaryAllowance: (json['salary_allowance'] as num?)?.toInt() ?? 0,
      advance13: json['advance13'] as String? ?? "",
      numbersUnitVacation:
          (json['numbers_unit_vacation'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$VacationCreatedModelToJson(
        VacationCreatedModel instance) =>
    <String, dynamic>{
      'employee_id': instance.employeeId,
      'company': instance.company,
      'employee_registration_number': instance.employeeRegistrationNumber,
      'vacation_scheduled_periods': instance.vacationScheduledPeriods,
      'salary_allowance': instance.salaryAllowance,
      'advance13': instance.advance13,
      'numbers_unit_vacation': instance.numbersUnitVacation,
    };
