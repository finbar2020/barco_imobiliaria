// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resin_params_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResinParamsModel _$ResinParamsModelFromJson(Map<String, dynamic> json) =>
    ResinParamsModel(
      avaliableValue: (json['avaliable_value'] as num?)?.toDouble() ?? 0.0,
      requestMaxValue: (json['request_max_value'] as num?)?.toDouble() ?? 0.0,
      refundMaxValue: (json['refund_max_value'] as num?)?.toDouble() ?? 0.0,
      refundTotalValue: (json['refund_total_value'] as num?)?.toDouble() ?? 0.0,
      requestOnPeriod: (json['request_on_period'] as num?)?.toInt(),
      pendingRequests: (json['pending_requests'] as num?)?.toInt(),
      maxFileSizeAllowed: (json['max_file_size_allowed'] as num?)?.toDouble(),
      filterStartDate: json['filter_start_date'] == null
          ? null
          : DateTime.parse(json['filter_start_date'] as String),
      filterEndDate: json['filter_end_date'] == null
          ? null
          : DateTime.parse(json['filter_end_date'] as String),
    );

Map<String, dynamic> _$ResinParamsModelToJson(ResinParamsModel instance) =>
    <String, dynamic>{
      'avaliable_value': instance.avaliableValue,
      'request_max_value': instance.requestMaxValue,
      'refund_max_value': instance.refundMaxValue,
      'refund_total_value': instance.refundTotalValue,
      'request_on_period': instance.requestOnPeriod,
      'pending_requests': instance.pendingRequests,
      'max_file_size_allowed': instance.maxFileSizeAllowed,
      'filter_start_date': instance.filterStartDate?.toIso8601String(),
      'filter_end_date': instance.filterEndDate?.toIso8601String(),
    };
