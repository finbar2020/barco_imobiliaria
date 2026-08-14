// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ia_bella_final_evaluation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IaBellaFinalEvaluationModel _$IaBellaFinalEvaluationModelFromJson(
        Map<String, dynamic> json) =>
    IaBellaFinalEvaluationModel(
      uuidSession: json['uuid_session'] as String?,
      evaluation: (json['evaluation'] as num?)?.toInt(),
      comment: json['comment'] as String?,
      requestResolved: json['request_resolved'] as bool?,
    );

Map<String, dynamic> _$IaBellaFinalEvaluationModelToJson(
        IaBellaFinalEvaluationModel instance) =>
    <String, dynamic>{
      'uuid_session': instance.uuidSession,
      'evaluation': instance.evaluation,
      'comment': instance.comment,
      'request_resolved': instance.requestResolved,
    };
