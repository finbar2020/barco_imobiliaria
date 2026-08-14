// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_formularies_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskFormulariesResponseModel _$TaskFormulariesResponseModelFromJson(
        Map<String, dynamic> json) =>
    TaskFormulariesResponseModel(
      formularies: (json['formularies'] as List<dynamic>)
          .map((e) => TaskFormularyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TaskFormulariesResponseModelToJson(
        TaskFormulariesResponseModel instance) =>
    <String, dynamic>{
      'formularies': instance.formularies,
    };

TaskFormularyModel _$TaskFormularyModelFromJson(Map<String, dynamic> json) =>
    TaskFormularyModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      responsibleName: json['responsible_name'] as String?,
      status: json['status'] as String,
      eventId: json['event_id'] as String?,
      position: (json['position'] as num).toInt(),
      authorId: json['author_id'] as String?,
      maxCreatedAt: json['max_created_at'] as String?,
      finishedAt: json['finished_at'] as String?,
      canStart: json['can_start'] as bool?,
    );

Map<String, dynamic> _$TaskFormularyModelToJson(TaskFormularyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'responsible_name': instance.responsibleName,
      'status': instance.status,
      'event_id': instance.eventId,
      'position': instance.position,
      'author_id': instance.authorId,
      'max_created_at': instance.maxCreatedAt,
      'finished_at': instance.finishedAt,
      'can_start': instance.canStart,
    };
