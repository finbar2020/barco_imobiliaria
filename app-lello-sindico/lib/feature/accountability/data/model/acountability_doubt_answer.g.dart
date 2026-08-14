// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'acountability_doubt_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountabilityDoubtAnswerModel _$AccountabilityDoubtAnswerModelFromJson(
        Map<String, dynamic> json) =>
    AccountabilityDoubtAnswerModel(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String,
      commentary: json['commentary'] as String,
      ppc: json['ppc'] as bool,
      await: json['await'] as bool,
    );

Map<String, dynamic> _$AccountabilityDoubtAnswerModelToJson(
        AccountabilityDoubtAnswerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'type': instance.type,
      'commentary': instance.commentary,
      'ppc': instance.ppc,
      'await': instance.await,
    };
