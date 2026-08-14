// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_collaborator_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollaboratorModel _$CollaboratorModelFromJson(Map<String, dynamic> json) =>
    CollaboratorModel(
      name: json['name'] as String? ?? '',
      numCra: json['num_cra'] as String? ?? '',
      numCad: json['num_cad'] as String? ?? '',
      reference: json['reference'] as String? ?? '',
      photo: json['photo'] as String? ?? '',
      date: json['date'] as String? ?? '',
      jobPosition: json['job_position'] as String? ?? '',
      shift: json['shift'] as String? ?? '',
    );

Map<String, dynamic> _$CollaboratorModelToJson(CollaboratorModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'num_cra': instance.numCra,
      'num_cad': instance.numCad,
      'reference': instance.reference,
      'photo': instance.photo,
      'date': instance.date,
      'job_position': instance.jobPosition,
      'shift': instance.shift,
    };
