// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payroll_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayrollEntryModel _$PayrollEntryModelFromJson(Map<String, dynamic> json) =>
    PayrollEntryModel()
      ..id = json['id'] as String?
      ..title = json['title'] as String?
      ..value = (json['value'] as num?)?.toDouble();

Map<String, dynamic> _$PayrollEntryModelToJson(PayrollEntryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'value': instance.value,
    };
