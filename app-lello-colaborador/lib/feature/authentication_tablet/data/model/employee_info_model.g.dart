// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeInfoModel _$EmployeeInfoModelFromJson(Map<String, dynamic> json) =>
    EmployeeInfoModel(
      numCra: json['num_cra'] as String? ?? "",
      numCad: json['num_cad'] as String? ?? "",
      cpf: json['cpf'] as String? ?? "",
      name: json['name'] as String? ?? "",
      jobPosition: json['job_position'] as String? ?? "",
      idLogin: json['id_login'] as String? ?? "",
      pictureHash: json['picture_hash'] as String? ?? "",
      registered: json['registered'] as bool? ?? false,
      status: json['status'] as String? ?? "pending",
    );

Map<String, dynamic> _$EmployeeInfoModelToJson(EmployeeInfoModel instance) =>
    <String, dynamic>{
      'num_cra': instance.numCra,
      'num_cad': instance.numCad,
      'cpf': instance.cpf,
      'name': instance.name,
      'job_position': instance.jobPosition,
      'id_login': instance.idLogin,
      'picture_hash': instance.pictureHash,
      'registered': instance.registered,
      'status': instance.status,
    };
