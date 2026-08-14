// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_day_appointments_check_in_data_day_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimesheetDayAppointmentsCheckInDataDayItemModel
    _$TimesheetDayAppointmentsCheckInDataDayItemModelFromJson(
            Map<String, dynamic> json) =>
        TimesheetDayAppointmentsCheckInDataDayItemModel(
          photoHash: json['photo_hash'] as String,
          checkInDateTime: DateTime.parse(json['check_in_date_time'] as String),
          distance: (json['distance'] as num).toDouble(),
          latitude: (json['latitude'] as num).toDouble(),
          longitude: (json['longitude'] as num).toDouble(),
          outOfRadius: json['out_of_radius'] as bool,
        );

Map<String, dynamic> _$TimesheetDayAppointmentsCheckInDataDayItemModelToJson(
        TimesheetDayAppointmentsCheckInDataDayItemModel instance) =>
    <String, dynamic>{
      'photo_hash': instance.photoHash,
      'check_in_date_time': instance.checkInDateTime.toIso8601String(),
      'distance': instance.distance,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'out_of_radius': instance.outOfRadius,
    };
