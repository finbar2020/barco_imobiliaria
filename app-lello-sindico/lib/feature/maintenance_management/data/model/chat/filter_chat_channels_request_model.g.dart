// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_chat_channels_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterChatChannelsRequestModel _$FilterChatChannelsRequestModelFromJson(
        Map<String, dynamic> json) =>
    FilterChatChannelsRequestModel(
      dtStart: json['dtStart'] as String?,
      untilDate: json['untilDate'] as String?,
      display: json['display'] as String?,
      dayCurrent: json['dayCurrent'] as String?,
      responsibleIds: (json['responsibleIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      assetIds: (json['assetIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      status:
          (json['status'] as List<dynamic>?)?.map((e) => e as String).toList(),
      typeTask: (json['typeTask'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$FilterChatChannelsRequestModelToJson(
        FilterChatChannelsRequestModel instance) =>
    <String, dynamic>{
      'dtStart': instance.dtStart,
      'untilDate': instance.untilDate,
      'display': instance.display,
      'dayCurrent': instance.dayCurrent,
      'responsibleIds': instance.responsibleIds,
      'assetIds': instance.assetIds,
      'status': instance.status,
      'typeTask': instance.typeTask,
    };
