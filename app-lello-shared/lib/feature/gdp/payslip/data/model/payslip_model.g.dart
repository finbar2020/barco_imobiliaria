// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payslip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayslipModel _$PayslipModelFromJson(Map<String, dynamic> json) => PayslipModel()
  ..name = json['name'] as String?
  ..description = json['description'] as String?
  ..type = json['type'] as String?
  ..processingDate = json['processing_date'] == null
      ? null
      : DateTime.parse(json['processing_date'] as String);

Map<String, dynamic> _$PayslipModelToJson(PayslipModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'type': instance.type,
      'processing_date': instance.processingDate?.toIso8601String(),
    };
