// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'acountability_doubt_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountabilityDoubtResponseModel _$AccountabilityDoubtResponseModelFromJson(
        Map<String, dynamic> json) =>
    AccountabilityDoubtResponseModel(
      id: json['id'] as String?,
      message: json['message'] as String,
      situation: $enumDecode(_$DoubtSituationEnumMap, json['situation']),
      attachments: (json['attachments'] as List<dynamic>)
          .map((e) => AttachmentsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      period: DateTime.parse(json['period'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      questionType: AccountabilityQuestionTypeModel.fromJson(
          json['question_type'] as Map<String, dynamic>),
      answers: (json['answers'] as List<dynamic>)
          .map((e) => AccountabilityDoubtAnswerModel.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AccountabilityDoubtResponseModelToJson(
        AccountabilityDoubtResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'situation': _$DoubtSituationEnumMap[instance.situation]!,
      'attachments': instance.attachments,
      'period': instance.period.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'question_type': instance.questionType,
      'answers': instance.answers,
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
