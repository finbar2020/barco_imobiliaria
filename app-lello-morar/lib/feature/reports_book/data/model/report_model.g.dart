// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportModel _$ReportModelFromJson(Map<String, dynamic> json) => ReportModel(
      idReport: json['id_report'] as String?,
      typeReport: json['type_report'] as String?,
      dateReport: json['date_report'] == null
          ? null
          : DateTime.parse(json['date_report'] as String),
      reportContents: (json['report_contents'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : ReportContentsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      closed: json['closed'] as bool?,
      newMessage: json['new_message'] as bool?,
      numReport: json['num_report'] as String?,
      notificationParameter: json['notification_parameter'] as String?,
      public: json['public'] as bool?,
    );

Map<String, dynamic> _$ReportModelToJson(ReportModel instance) =>
    <String, dynamic>{
      'id_report': instance.idReport,
      'type_report': instance.typeReport,
      'date_report': instance.dateReport?.toIso8601String(),
      'report_contents': instance.reportContents,
      'closed': instance.closed,
      'new_message': instance.newMessage,
      'num_report': instance.numReport,
      'notification_parameter': instance.notificationParameter,
      'public': instance.public,
    };
