// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_day_appointments_check_in_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimesheetDayAppointmentsCheckInDataModel
    _$TimesheetDayAppointmentsCheckInDataModelFromJson(
            Map<String, dynamic> json) =>
        TimesheetDayAppointmentsCheckInDataModel(
          name: json['name'] as String,
          craNumber: json['cra_number'] as String,
          checkInDays: (json['check_in_days'] as List<dynamic>)
              .map((e) => TimesheetDayAppointmentsCheckInDataDayModel.fromJson(
                  e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$TimesheetDayAppointmentsCheckInDataModelToJson(
        TimesheetDayAppointmentsCheckInDataModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'cra_number': instance.craNumber,
      'check_in_days': instance.checkInDays,
    };
