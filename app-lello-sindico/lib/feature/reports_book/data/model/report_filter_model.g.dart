// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_filter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportFilterModel _$ReportFilterModelFromJson(Map<String, dynamic> json) =>
    ReportFilterModel(
      dateFrom: json['date_from'] == null
          ? null
          : DateTime.parse(json['date_from'] as String),
      dateTo: json['date_to'] == null
          ? null
          : DateTime.parse(json['date_to'] as String),
      type: (json['type'] as num?)?.toInt(),
      closed: json['closed'] as bool?,
      unitId: json['unit_id'] as String?,
      showOnlyNewReports: json['show_only_new_reports'] as bool? ?? false,
      showOnlyReplies: json['show_only_replies'] as bool? ?? false,
    );

Map<String, dynamic> _$ReportFilterModelToJson(ReportFilterModel instance) =>
    <String, dynamic>{
      'date_from': instance.dateFrom?.toIso8601String(),
      'date_to': instance.dateTo?.toIso8601String(),
      'type': instance.type,
      'closed': instance.closed,
      'unit_id': instance.unitId,
      'show_only_new_reports': instance.showOnlyNewReports,
      'show_only_replies': instance.showOnlyReplies,
    };
