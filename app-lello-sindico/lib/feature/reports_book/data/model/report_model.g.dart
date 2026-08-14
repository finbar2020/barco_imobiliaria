// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportModel _$ReportModelFromJson(Map<String, dynamic> json) => ReportModel(
      idReport: json['id_report'] as String?,
      unit: json['unit'] == null
          ? null
          : UnitModel.fromJson(json['unit'] as Map<String, dynamic>),
      typeReport: json['type_report'] as String?,
      dateReport: json['date_report'] == null
          ? null
          : DateTime.parse(json['date_report'] as String),
      reportContents: (json['report_contents'] as List<dynamic>?)
          ?.map((e) => ReportContentsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isPublic: json['is_public'] as bool?,
      closed: json['closed'] as bool?,
      newMessage: json['new_message'] as bool?,
      numReport: json['num_report'] as String?,
      notificationParameter: json['notification_parameter'] as String?,
    );

Map<String, dynamic> _$ReportModelToJson(ReportModel instance) =>
    <String, dynamic>{
      'id_report': instance.idReport,
      'unit': instance.unit,
      'type_report': instance.typeReport,
      'date_report': instance.dateReport?.toIso8601String(),
      'report_contents': instance.reportContents,
      'closed': instance.closed,
      'new_message': instance.newMessage,
      'is_public': instance.isPublic,
      'num_report': instance.numReport,
      'notification_parameter': instance.notificationParameter,
    };
