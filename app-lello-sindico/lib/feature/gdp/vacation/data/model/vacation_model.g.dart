// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VacationModel _$VacationModelFromJson(Map<String, dynamic> json) =>
    VacationModel(
      employee: json['employee'] == null
          ? null
          : EmployeeModel.fromJson(json['employee'] as Map<String, dynamic>),
      employeeId: json['employee_id'] as String?,
      company: (json['company'] as num?)?.toInt(),
      employeeType: (json['employee_type'] as num?)?.toInt(),
      employeeRegistrationNumber:
          json['employee_registration_number'] as String?,
      acquisitivePeriodStartDate:
          json['acquisitive_period_start_date'] as String?,
      acquisitivePeriodEndDate: json['acquisitive_period_end_date'] as String?,
      reference: json['reference'] as String?,
      employeeName: json['employee_name'] as String?,
      admissionDate: json['admission_date'] as String?,
      deadLine: json['dead_line'] as String?,
      allowanceDays: (json['allowance_days'] as num?)?.toDouble() ?? 0.0,
      numberAbsences: (json['number_absences'] as num?)?.toDouble() ?? 0.0,
      vacationStartDate: json['vacation_start_date'] as String?,
      vacationEndDate: json['vacation_end_date'] as String?,
      scheduledDays: (json['scheduled_days'] as num?)?.toInt() ?? 0,
      salaryAllowance: (json['salary_allowance'] as num?)?.toInt() ?? 0,
      advance13: json['advance13'] as String? ?? "",
      totalVacation: (json['total_vacation'] as num?)?.toInt() ?? 0,
      numbersUnitVacation:
          (json['numbers_unit_vacation'] as num?)?.toInt() ?? 0,
      scheduledVacations: (json['scheduled_vacations'] as List<dynamic>?)
          ?.map((e) => VacationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VacationModelToJson(VacationModel instance) =>
    <String, dynamic>{
      'employee': instance.employee,
      'employee_id': instance.employeeId,
      'company': instance.company,
      'employee_type': instance.employeeType,
      'employee_registration_number': instance.employeeRegistrationNumber,
      'acquisitive_period_start_date': instance.acquisitivePeriodStartDate,
      'acquisitive_period_end_date': instance.acquisitivePeriodEndDate,
      'reference': instance.reference,
      'employee_name': instance.employeeName,
      'admission_date': instance.admissionDate,
      'dead_line': instance.deadLine,
      'allowance_days': instance.allowanceDays,
      'number_absences': instance.numberAbsences,
      'vacation_start_date': instance.vacationStartDate,
      'vacation_end_date': instance.vacationEndDate,
      'scheduled_days': instance.scheduledDays,
      'salary_allowance': instance.salaryAllowance,
      'advance13': instance.advance13,
      'total_vacation': instance.totalVacation,
      'numbers_unit_vacation': instance.numbersUnitVacation,
      'scheduled_vacations': instance.scheduledVacations,
    };
