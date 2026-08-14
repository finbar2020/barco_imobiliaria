// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'efficiency_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EfficiencyItemModel _$EfficiencyItemModelFromJson(Map<String, dynamic> json) =>
    EfficiencyItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      done: (json['done'] as num).toInt(),
      notStarted: (json['not_started'] as num).toInt(),
      draft: (json['draft'] as num).toInt(),
    );

Map<String, dynamic> _$EfficiencyItemModelToJson(
        EfficiencyItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'done': instance.done,
      'not_started': instance.notStarted,
      'draft': instance.draft,
    };

EfficiencyResponseModel _$EfficiencyResponseModelFromJson(
        Map<String, dynamic> json) =>
    EfficiencyResponseModel(
      efficiencyResponse: (json['efficiency_response'] as List<dynamic>)
          .map((e) => EfficiencyItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      taskSummary: TaskSummaryModel.fromJson(
          json['task_summary'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EfficiencyResponseModelToJson(
        EfficiencyResponseModel instance) =>
    <String, dynamic>{
      'efficiency_response': instance.efficiencyResponse,
      'task_summary': instance.taskSummary,
    };
