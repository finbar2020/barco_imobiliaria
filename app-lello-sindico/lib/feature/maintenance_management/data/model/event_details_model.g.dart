// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventDetailsModel _$EventDetailsModelFromJson(Map<String, dynamic> json) =>
    EventDetailsModel(
      id: json['id'] as String,
      lastContentAnswers: json['last_content_answers'] == null
          ? null
          : LastContentAnswersModel.fromJson(
              json['last_content_answers'] as Map<String, dynamic>),
      parentScheduleEvent: json['parent_schedule_event'] == null
          ? null
          : ParentScheduleEventModel.fromJson(
              json['parent_schedule_event'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EventDetailsModelToJson(EventDetailsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'last_content_answers': instance.lastContentAnswers?.toJson(),
      'parent_schedule_event': instance.parentScheduleEvent?.toJson(),
    };

LastContentAnswersModel _$LastContentAnswersModelFromJson(
        Map<String, dynamic> json) =>
    LastContentAnswersModel(
      formularyId: json['formulary_id'] as String,
      deletedAt: json['deleted_at'] as String?,
      createdAt: json['created_at'] as String,
      finishedAt: json['finished_at'] as String?,
      partnerId: json['partner_id'] as String?,
      authorId: json['author_id'] as String?,
      updatedAt: json['updated_at'] as String,
      localId: json['local_id'] as String?,
      status: json['status'] as String,
      taskId: json['task_id'] as String,
      responsibleId: json['responsible_id'] as String?,
      responsibleType: json['responsible_type'] as String?,
      responsibleName: json['responsible_name'] as String?,
      formulary: json['formulary'] == null
          ? null
          : FormularyModel.fromJson(json['formulary'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LastContentAnswersModelToJson(
        LastContentAnswersModel instance) =>
    <String, dynamic>{
      'formulary_id': instance.formularyId,
      'deleted_at': instance.deletedAt,
      'created_at': instance.createdAt,
      'finished_at': instance.finishedAt,
      'partner_id': instance.partnerId,
      'author_id': instance.authorId,
      'updated_at': instance.updatedAt,
      'local_id': instance.localId,
      'status': instance.status,
      'task_id': instance.taskId,
      'responsible_id': instance.responsibleId,
      'responsible_type': instance.responsibleType,
      'responsible_name': instance.responsibleName,
      'formulary': instance.formulary?.toJson(),
    };

FormularyModel _$FormularyModelFromJson(Map<String, dynamic> json) =>
    FormularyModel(
      id: json['id'] as String,
      name: json['name'] as String,
      position: (json['position'] as num).toInt(),
      procedureId: json['procedure_id'] as String,
      enabled: json['enabled'] as bool,
      description: json['description'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FormularyModelToJson(FormularyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'position': instance.position,
      'procedure_id': instance.procedureId,
      'enabled': instance.enabled,
      'description': instance.description,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'questions': instance.questions.map((e) => e.toJson()).toList(),
    };

QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) =>
    QuestionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      position: (json['position'] as num).toInt(),
      formularyId: json['formulary_id'] as String,
      hidden: json['hidden'] as bool,
      required: json['required'] as bool,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      fieldType: json['field_type'] as String,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => OptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      expressions: (json['expressions'] as List<dynamic>?)
          ?.map((e) => ExpressionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuestionModelToJson(QuestionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'position': instance.position,
      'formulary_id': instance.formularyId,
      'hidden': instance.hidden,
      'required': instance.required,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'field_type': instance.fieldType,
      'options': instance.options?.map((e) => e.toJson()).toList(),
      'expressions': instance.expressions?.map((e) => e.toJson()).toList(),
    };

OptionModel _$OptionModelFromJson(Map<String, dynamic> json) => OptionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      position: (json['position'] as num).toInt(),
      questionId: json['question_id'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$OptionModelToJson(OptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'position': instance.position,
      'question_id': instance.questionId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

ExpressionModel _$ExpressionModelFromJson(Map<String, dynamic> json) =>
    ExpressionModel(
      id: json['id'] as String,
      factors: (json['factors'] as List<dynamic>)
          .map((e) => FactorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExpressionModelToJson(ExpressionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'factors': instance.factors.map((e) => e.toJson()).toList(),
    };

FactorModel _$FactorModelFromJson(Map<String, dynamic> json) => FactorModel(
      targetValue: json['target_value'] as String,
      originId: json['origin_id'] as String,
      comparisonType: json['comparison_type'] as String,
    );

Map<String, dynamic> _$FactorModelToJson(FactorModel instance) =>
    <String, dynamic>{
      'target_value': instance.targetValue,
      'origin_id': instance.originId,
      'comparison_type': instance.comparisonType,
    };

ParentScheduleEventModel _$ParentScheduleEventModelFromJson(
        Map<String, dynamic> json) =>
    ParentScheduleEventModel(
      id: json['id'] as String,
    );

Map<String, dynamic> _$ParentScheduleEventModelToJson(
        ParentScheduleEventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
    };
