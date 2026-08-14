// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_day_appointments_check_in_data_day_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimesheetDayAppointmentsCheckInDataDayModel
    _$TimesheetDayAppointmentsCheckInDataDayModelFromJson(
            Map<String, dynamic> json) =>
        TimesheetDayAppointmentsCheckInDataDayModel(
          date: DateTime.parse(json['date'] as String),
          checkInRecords: (json['check_in_records'] as List<dynamic>)
              .map((e) =>
                  TimesheetDayAppointmentsCheckInDataDayItemModel.fromJson(
                      e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$TimesheetDayAppointmentsCheckInDataDayModelToJson(
        TimesheetDayAppointmentsCheckInDataDayModel instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'check_in_records': instance.checkInRecords,
    };
