// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'acountability_doubt_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountabilityDoubtRequestModel _$AccountabilityDoubtRequestModelFromJson(
        Map<String, dynamic> json) =>
    AccountabilityDoubtRequestModel(
      message: json['message'] as String,
      attachments: (json['attachments'] as List<dynamic>)
          .map((e) =>
              AttachmentsRequestModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      period: DateTime.parse(json['period'] as String),
      typeId: json['type_id'] as String,
      enteries: (json['enteries'] as List<dynamic>)
          .map((e) => AccountabilityGroupedAccaountEntrieModel.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AccountabilityDoubtRequestModelToJson(
        AccountabilityDoubtRequestModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'attachments': instance.attachments,
      'period': instance.period.toIso8601String(),
      'type_id': instance.typeId,
      'enteries': instance.enteries,
    };
