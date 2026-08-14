// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_task_from_schedule_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTaskFromScheduleResponseModel
    _$CreateTaskFromScheduleResponseModelFromJson(Map<String, dynamic> json) =>
        CreateTaskFromScheduleResponseModel(
          task: TaskCreatedModel.fromJson(json['task'] as Map<String, dynamic>),
          event:
              EventCreatedModel.fromJson(json['event'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$CreateTaskFromScheduleResponseModelToJson(
        CreateTaskFromScheduleResponseModel instance) =>
    <String, dynamic>{
      'task': instance.task,
      'event': instance.event,
    };

TaskCreatedModel _$TaskCreatedModelFromJson(Map<String, dynamic> json) =>
    TaskCreatedModel(
      id: json['id'] as String,
      name: json['name'] as String,
      currentResponsibleName: json['current_responsible_name'] as String?,
      currentResponsibleId: json['current_responsible_id'] as String?,
    );

Map<String, dynamic> _$TaskCreatedModelToJson(TaskCreatedModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'current_responsible_name': instance.currentResponsibleName,
      'current_responsible_id': instance.currentResponsibleId,
    };

EventCreatedModel _$EventCreatedModelFromJson(Map<String, dynamic> json) =>
    EventCreatedModel(
      id: json['id'] as String,
      name: json['name'] as String?,
      lastContentAnswers: json['last_content_answers'] == null
          ? null
          : LastContentAnswersModel.fromJson(
              json['last_content_answers'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EventCreatedModelToJson(EventCreatedModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'last_content_answers': instance.lastContentAnswers,
    };

LastContentAnswersModel _$LastContentAnswersModelFromJson(
        Map<String, dynamic> json) =>
    LastContentAnswersModel(
      questionId: json['questionId'] as String,
      type: json['type'] as String,
      content: json['content'] as String,
      updatedAt: json['updatedAt'] as String,
      formularyId: json['formularyId'] as String,
      deletedAt: json['deletedAt'] as String?,
    );

Map<String, dynamic> _$LastContentAnswersModelToJson(
        LastContentAnswersModel instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'type': instance.type,
      'content': instance.content,
      'updatedAt': instance.updatedAt,
      'formularyId': instance.formularyId,
      'deletedAt': instance.deletedAt,
    };
