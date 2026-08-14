// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comfort_completed_request_paginated_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComfortCompletedRequestPaginatedModel
    _$ComfortCompletedRequestPaginatedModelFromJson(
            Map<String, dynamic> json) =>
        ComfortCompletedRequestPaginatedModel(
          meta: json['meta'] == null
              ? null
              : MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
          data: (json['data'] as List<dynamic>?)
              ?.map((e) => ComfortCompletedRequestModel.fromJson(
                  e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$ComfortCompletedRequestPaginatedModelToJson(
        ComfortCompletedRequestPaginatedModel instance) =>
    <String, dynamic>{
      'meta': instance.meta,
      'data': instance.data,
    };
