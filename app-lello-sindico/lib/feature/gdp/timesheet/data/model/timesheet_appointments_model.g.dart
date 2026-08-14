// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_appointments_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentsModel _$AppointmentsModelFromJson(Map<String, dynamic> json) =>
    AppointmentsModel(
      numCad: json['num_cad'] as String? ?? '',
      reference: json['reference'] as String? ?? '',
      photo: json['photo'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      distance: (json['distance'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$AppointmentsModelToJson(AppointmentsModel instance) =>
    <String, dynamic>{
      'num_cad': instance.numCad,
      'reference': instance.reference,
      'photo': instance.photo,
      'date': instance.date.toIso8601String(),
      'distance': instance.distance,
    };
