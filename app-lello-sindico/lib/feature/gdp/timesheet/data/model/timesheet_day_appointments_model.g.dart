// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_day_appointments_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DayAppointmentsModel _$DayAppointmentsModelFromJson(
        Map<String, dynamic> json) =>
    DayAppointmentsModel(
      collaborator: CollaboratorModel.fromJson(
          json['collaborator'] as Map<String, dynamic>),
      appointments: (json['appointments'] as List<dynamic>)
          .map((e) => AppointmentsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      condoLocation: CondoLocationModel.fromJson(
          json['condo_location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DayAppointmentsModelToJson(
        DayAppointmentsModel instance) =>
    <String, dynamic>{
      'collaborator': instance.collaborator,
      'appointments': instance.appointments,
      'condo_location': instance.condoLocation,
    };
