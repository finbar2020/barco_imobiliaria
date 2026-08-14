// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_employee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimesheetEmployeeModel _$TimesheetEmployeeModelFromJson(
        Map<String, dynamic> json) =>
    TimesheetEmployeeModel()
      ..id = json['id'] as String?
      ..name = json['name'] as String?
      ..dob = json['dob'] == null ? null : DateTime.parse(json['dob'] as String)
      ..role = json['role'] as String?
      ..hiringDate = json['hiring_date'] == null
          ? null
          : DateTime.parse(json['hiring_date'] as String)
      ..status = json['status'] as String?
      ..imageHash = json['image_hash'] as String?
      ..numCra = json['num_cra'] as String?
      ..turn = json['turn'] as String?;

Map<String, dynamic> _$TimesheetEmployeeModelToJson(
        TimesheetEmployeeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'dob': instance.dob?.toIso8601String(),
      'role': instance.role,
      'hiring_date': instance.hiringDate?.toIso8601String(),
      'status': instance.status,
      'image_hash': instance.imageHash,
      'num_cra': instance.numCra,
      'turn': instance.turn,
    };
