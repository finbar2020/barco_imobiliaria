// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_create_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportCreateModel _$ReportCreateModelFromJson(Map<String, dynamic> json) =>
    ReportCreateModel(
      idUnit: json['id_unit'] as String?,
      typeReport: json['type_report'] as String?,
      dateReport: json['date_report'] == null
          ? null
          : DateTime.parse(json['date_report'] as String),
      content: json['content'] as String?,
      public: json['public'] as bool?,
    );

Map<String, dynamic> _$ReportCreateModelToJson(ReportCreateModel instance) =>
    <String, dynamic>{
      'id_unit': instance.idUnit,
      'type_report': instance.typeReport,
      'date_report': instance.dateReport?.toIso8601String(),
      'content': instance.content,
      'public': instance.public,
    };
