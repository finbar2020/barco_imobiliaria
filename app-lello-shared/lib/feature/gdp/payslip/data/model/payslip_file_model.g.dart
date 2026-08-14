// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payslip_file_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayslipFileModel _$PayslipFileModelFromJson(Map<String, dynamic> json) =>
    PayslipFileModel()
      ..id = json['id'] as String?
      ..name = json['name'] as String?
      ..type = json['type'] as String?
      ..data = json['data'] as String?;

Map<String, dynamic> _$PayslipFileModelToJson(PayslipFileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'data': instance.data,
    };
