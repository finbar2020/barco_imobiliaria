// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BilletModel _$BilletModelFromJson(Map<String, dynamic> json) => BilletModel(
      id: json['id'] as String?,
      value: (json['value'] as num?)?.toDouble(),
      period: json['period'] == null
          ? null
          : DateTime.parse(json['period'] as String),
      situation: json['situation'] as String?,
      code: json['code'] as String?,
      nrBillet: json['nr_billet'] as String?,
      founds: (json['founds'] as List<dynamic>?)
              ?.map((e) => BilletFoundModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      instructions: json['instructions'] == null
          ? null
          : BilletInstructionsModel.fromJson(
              json['instructions'] as Map<String, dynamic>),
      name: json['name'] as String?,
      isDuplicate: json['is_duplicate'] as bool?,
    )..notificationParameter = json['notification_parameter'] as String?;

Map<String, dynamic> _$BilletModelToJson(BilletModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'period': instance.period?.toIso8601String(),
      'situation': instance.situation,
      'nr_billet': instance.nrBillet,
      'code': instance.code,
      'notification_parameter': instance.notificationParameter,
      'name': instance.name,
      'is_duplicate': instance.isDuplicate,
      'founds': instance.founds,
      'instructions': instance.instructions,
    };
