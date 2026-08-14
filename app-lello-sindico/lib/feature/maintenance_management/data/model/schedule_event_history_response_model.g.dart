// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_event_history_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleEventHistoryResponseModel _$ScheduleEventHistoryResponseModelFromJson(
        Map<String, dynamic> json) =>
    ScheduleEventHistoryResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : ScheduleEventHistoryDataModel.fromJson(
              json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ScheduleEventHistoryResponseModelToJson(
        ScheduleEventHistoryResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

ScheduleEventHistoryDataModel _$ScheduleEventHistoryDataModelFromJson(
        Map<String, dynamic> json) =>
    ScheduleEventHistoryDataModel(
      timeDescription: json['time_description'] as String?,
      timeStart: json['time_start'] as String?,
      timeEnd: json['time_end'] as String?,
      name: json['name'] as String?,
      localOrAsset: json['local_or_asset'] as String?,
      dtStart: json['dt_start'] as String?,
      until: json['until'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) =>
              ScheduleEventHistoryItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      allDay: json['all_day'] as bool?,
    );

Map<String, dynamic> _$ScheduleEventHistoryDataModelToJson(
        ScheduleEventHistoryDataModel instance) =>
    <String, dynamic>{
      'time_description': instance.timeDescription,
      'time_start': instance.timeStart,
      'time_end': instance.timeEnd,
      'name': instance.name,
      'local_or_asset': instance.localOrAsset,
      'dt_start': instance.dtStart,
      'until': instance.until,
      'items': instance.items,
      'all_day': instance.allDay,
    };

ScheduleEventHistoryItemModel _$ScheduleEventHistoryItemModelFromJson(
        Map<String, dynamic> json) =>
    ScheduleEventHistoryItemModel(
      dtStart: json['dt_start'] as String?,
      status: json['status'] as String?,
      until: json['until'] as String?,
      activityType: json['activity_type'] as String?,
      descriptionActivityType: json['description_activity_type'] as String?,
      subjectName: json['subject_name'] as String?,
      updatedAt: json['updated_at'] as String?,
      updatedAtFormatted: json['updated_at_formatted'] as String?,
      responsibleId: json['responsible_id'] as String?,
      responsibleName: json['responsible_name'] as String?,
    );

Map<String, dynamic> _$ScheduleEventHistoryItemModelToJson(
        ScheduleEventHistoryItemModel instance) =>
    <String, dynamic>{
      'dt_start': instance.dtStart,
      'status': instance.status,
      'until': instance.until,
      'activity_type': instance.activityType,
      'description_activity_type': instance.descriptionActivityType,
      'subject_name': instance.subjectName,
      'updated_at': instance.updatedAt,
      'updated_at_formatted': instance.updatedAtFormatted,
      'responsible_id': instance.responsibleId,
      'responsible_name': instance.responsibleName,
    };
