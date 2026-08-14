// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_control_itens_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessControlItensModel _$AccessControlItensModelFromJson(
        Map<String, dynamic> json) =>
    AccessControlItensModel(
      recurrenceValue: (json['recurrence_value'] as num?)?.toInt(),
      start: json['start'] == null
          ? null
          : AccessControlDateModel.fromJson(
              json['start'] as Map<String, dynamic>),
      end: json['end'] == null
          ? null
          : AccessControlDateModel.fromJson(
              json['end'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AccessControlItensModelToJson(
        AccessControlItensModel instance) =>
    <String, dynamic>{
      'recurrence_value': instance.recurrenceValue,
      'start': instance.start,
      'end': instance.end,
    };
