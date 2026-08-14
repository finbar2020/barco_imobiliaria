// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resin_refund_dto_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResinRefundDTOModel _$ResinRefundDTOModelFromJson(Map<String, dynamic> json) =>
    ResinRefundDTOModel(
      id: json['id'] as String?,
      value: (json['value'] as num).toDouble(),
      receipts: (json['receipts'] as List<dynamic>)
          .map((e) =>
              ResinRefundReceiptModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String,
      type: json['type'] as String,
      accountId: json['account_id'] as String,
      requesterId: json['requester_id'] as String,
      requestDate: json['request_date'] == null
          ? null
          : DateTime.parse(json['request_date'] as String),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$ResinRefundDTOModelToJson(
        ResinRefundDTOModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'receipts': instance.receipts,
      'description': instance.description,
      'status': instance.status,
      'type': instance.type,
      'account_id': instance.accountId,
      'requester_id': instance.requesterId,
      'request_date': instance.requestDate?.toIso8601String(),
    };
