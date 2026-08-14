// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkflowDataModel _$WorkflowDataModelFromJson(Map<String, dynamic> json) =>
    WorkflowDataModel(
      id: json['id'] as String,
      assets: json['assets'] as String,
      floor: json['floor'] as String,
      localsCount: (json['localsCount'] as num).toInt(),
      workflowUsers: json['workflowUsers'] as String,
      condominiumName: json['condominiumName'] as String,
      blocksCount: (json['blocksCount'] as num).toInt(),
      unitsCount: (json['unitsCount'] as num).toInt(),
    );

Map<String, dynamic> _$WorkflowDataModelToJson(WorkflowDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'assets': instance.assets,
      'floor': instance.floor,
      'localsCount': instance.localsCount,
      'workflowUsers': instance.workflowUsers,
      'condominiumName': instance.condominiumName,
      'blocksCount': instance.blocksCount,
      'unitsCount': instance.unitsCount,
    };
