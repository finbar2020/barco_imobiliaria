// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_by_sector_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskBySectorResponseModel _$TaskBySectorResponseModelFromJson(
        Map<String, dynamic> json) =>
    TaskBySectorResponseModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => TaskBySectorDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TaskBySectorResponseModelToJson(
        TaskBySectorResponseModel instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
