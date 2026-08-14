// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_control_recurrence_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessControlRecurrenceModel _$AccessControlRecurrenceModelFromJson(
        Map<String, dynamic> json) =>
    AccessControlRecurrenceModel(
      idRecurrence: json['id_recurrence'] as String?,
      recurrenceType: json['recurrence_type'] as String?,
      interval: (json['interval'] as num?)?.toInt(),
      itens: (json['itens'] as List<dynamic>?)
              ?.map((e) => e == null
                  ? null
                  : AccessControlItensModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$AccessControlRecurrenceModelToJson(
        AccessControlRecurrenceModel instance) =>
    <String, dynamic>{
      'id_recurrence': instance.idRecurrence,
      'recurrence_type': instance.recurrenceType,
      'interval': instance.interval,
      'itens': instance.itens,
    };
