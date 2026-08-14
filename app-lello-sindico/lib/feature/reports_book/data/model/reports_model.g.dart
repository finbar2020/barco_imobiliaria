// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reports_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportsModel _$ReportsModelFromJson(Map<String, dynamic> json) => ReportsModel(
      meta: json['meta'] == null
          ? null
          : ReportMetaModel.fromJson(json['meta'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ReportModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReportsModelToJson(ReportsModel instance) =>
    <String, dynamic>{
      'meta': instance.meta,
      'data': instance.data,
    };
