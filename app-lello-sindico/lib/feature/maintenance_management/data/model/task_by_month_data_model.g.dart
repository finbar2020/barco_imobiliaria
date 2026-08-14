// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_by_month_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskByMonthDataModel _$TaskByMonthDataModelFromJson(
        Map<String, dynamic> json) =>
    TaskByMonthDataModel(
      name: json['name'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) =>
              TaskByMonthDataPointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TaskByMonthDataModelToJson(
        TaskByMonthDataModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'data': instance.data,
    };
