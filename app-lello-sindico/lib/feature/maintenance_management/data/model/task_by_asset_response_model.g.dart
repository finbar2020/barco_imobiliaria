// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_by_asset_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskByAssetResponseModel _$TaskByAssetResponseModelFromJson(
        Map<String, dynamic> json) =>
    TaskByAssetResponseModel(
      dataTaskByAssetResponse: (json['data_task_by_asset_response']
              as List<dynamic>?)
          ?.map((e) => TaskByAssetDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TaskByAssetResponseModelToJson(
        TaskByAssetResponseModel instance) =>
    <String, dynamic>{
      'data_task_by_asset_response': instance.dataTaskByAssetResponse,
    };
