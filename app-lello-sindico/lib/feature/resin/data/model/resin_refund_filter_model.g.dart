// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resin_refund_filter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResinRefundFilterModel _$ResinRefundFilterModelFromJson(
        Map<String, dynamic> json) =>
    ResinRefundFilterModel(
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      protocol: json['protocol'] as String?,
      status: json['status'] as String?,
      inconsistency: json['inconsistency'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$ResinRefundFilterModelToJson(
        ResinRefundFilterModel instance) =>
    <String, dynamic>{
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'protocol': instance.protocol,
      'status': instance.status,
      'inconsistency': instance.inconsistency,
      'type': instance.type,
    };
