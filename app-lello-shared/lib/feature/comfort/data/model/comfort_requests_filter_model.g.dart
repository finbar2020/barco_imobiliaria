// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comfort_requests_filter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComfortRequestsFilterModel _$ComfortRequestsFilterModelFromJson(
        Map<String, dynamic> json) =>
    ComfortRequestsFilterModel(
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      status: json['status'] as String?,
      subcategories: json['subcategories'] as String?,
    );

Map<String, dynamic> _$ComfortRequestsFilterModelToJson(
        ComfortRequestsFilterModel instance) =>
    <String, dynamic>{
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'status': instance.status,
      'subcategories': instance.subcategories,
    };
