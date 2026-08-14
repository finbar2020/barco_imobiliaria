// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_by_local_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskByLocalResponseModel _$TaskByLocalResponseModelFromJson(
        Map<String, dynamic> json) =>
    TaskByLocalResponseModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => TaskByLocalDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TaskByLocalResponseModelToJson(
        TaskByLocalResponseModel instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
