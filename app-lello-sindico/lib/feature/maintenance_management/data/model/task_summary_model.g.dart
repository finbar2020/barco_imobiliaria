// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskSummaryModel _$TaskSummaryModelFromJson(Map<String, dynamic> json) =>
    TaskSummaryModel(
      total: (json['total'] as num).toInt(),
      done: (json['done'] as num).toInt(),
      notStarted: (json['notStarted'] as num).toInt(),
      draft: (json['draft'] as num).toInt(),
    );

Map<String, dynamic> _$TaskSummaryModelToJson(TaskSummaryModel instance) =>
    <String, dynamic>{
      'total': instance.total,
      'done': instance.done,
      'notStarted': instance.notStarted,
      'draft': instance.draft,
    };
