// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeModel _$EmployeeModelFromJson(Map<String, dynamic> json) =>
    EmployeeModel()
      ..id = json['id'] as String?
      ..name = json['name'] as String?
      ..dob = json['dob'] == null ? null : DateTime.parse(json['dob'] as String)
      ..role = json['role'] as String?
      ..hiringDate = json['hiring_date'] == null
          ? null
          : DateTime.parse(json['hiring_date'] as String)
      ..phone = json['phone'] as String?
      ..phone2 = json['phone2'] as String?
      ..address = json['address'] == null
          ? null
          : AddressModel.fromJson(json['address'] as Map<String, dynamic>)
      ..salary = (json['salary'] as num?)?.toDouble()
      ..schooling = json['schooling'] as String?
      ..status = json['status'] as String?
      ..picture = json['picture'] as String?;

Map<String, dynamic> _$EmployeeModelToJson(EmployeeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'dob': instance.dob?.toIso8601String(),
      'role': instance.role,
      'hiring_date': instance.hiringDate?.toIso8601String(),
      'phone': instance.phone,
      'phone2': instance.phone2,
      'address': instance.address,
      'salary': instance.salary,
      'schooling': instance.schooling,
      'status': instance.status,
      'picture': instance.picture,
    };
