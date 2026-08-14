// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_report_day_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimesheetReportDayModel _$TimesheetReportDayModelFromJson(
        Map<String, dynamic> json) =>
    TimesheetReportDayModel()
      ..totalAmount = (json['total_amount'] as num?)?.toInt()
      ..presentAmount = (json['present_amount'] as num?)?.toInt()
      ..dayOffAmount = (json['day_off_amount'] as num?)?.toInt()
      ..vacationAmount = (json['vacation_amount'] as num?)?.toInt()
      ..unmarkedAmount = (json['unmarked_amount'] as num?)?.toInt()
      ..shiftNotStartedAmount =
          (json['shift_not_started_amount'] as num?)?.toInt()
      ..attestationAmount = (json['attestation_amount'] as num?)?.toInt()
      ..clearanceAmount = (json['clearance_amount'] as num?)?.toInt()
      ..extraHours = (json['extra_hours'] as num?)?.toInt();

Map<String, dynamic> _$TimesheetReportDayModelToJson(
        TimesheetReportDayModel instance) =>
    <String, dynamic>{
      'total_amount': instance.totalAmount,
      'present_amount': instance.presentAmount,
      'day_off_amount': instance.dayOffAmount,
      'vacation_amount': instance.vacationAmount,
      'unmarked_amount': instance.unmarkedAmount,
      'shift_not_started_amount': instance.shiftNotStartedAmount,
      'attestation_amount': instance.attestationAmount,
      'clearance_amount': instance.clearanceAmount,
      'extra_hours': instance.extraHours,
    };
