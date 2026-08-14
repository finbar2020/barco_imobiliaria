// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'acountability_doubt_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountabilityDoubtModel _$AccountabilityDoubtModelFromJson(
        Map<String, dynamic> json) =>
    AccountabilityDoubtModel(
      id: json['id'] as String?,
      message: json['message'] as String,
      questionSituation:
          $enumDecode(_$DoubtSituationEnumMap, json['question_situation']),
      attachments: (json['attachments'] as List<dynamic>)
          .map((e) => AttachmentsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      period: DateTime.parse(json['period'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      doubtType: AccountabilityQuestionTypeModel.fromJson(
          json['doubt_type'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AccountabilityDoubtModelToJson(
        AccountabilityDoubtModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'question_situation':
          _$DoubtSituationEnumMap[instance.questionSituation]!,
      'attachments': instance.attachments,
      'period': instance.period.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'doubt_type': instance.doubtType,
    };

const _$DoubtSituationEnumMap = {
  DoubtSituation.in_approval: 'in_approval',
  DoubtSituation.in_progress: 'in_progress',
  DoubtSituation.delayed: 'delayed',
  DoubtSituation.completed: 'completed',
  DoubtSituation.completed_delay: 'completed_delay',
  DoubtSituation.canceled_user: 'canceled_user',
  DoubtSituation.canceled_deadline: 'canceled_deadline',
  DoubtSituation.reproved: 'reproved',
};
