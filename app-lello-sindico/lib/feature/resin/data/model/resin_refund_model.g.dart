// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resin_refund_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResinRefundModel _$ResinRefundModelFromJson(Map<String, dynamic> json) =>
    ResinRefundModel(
      id: json['id'] as String? ?? "",
      requestDate: json['request_date'] == null
          ? null
          : DateTime.parse(json['request_date'] as String),
      requester: json['requester'] as String? ?? "",
      status: json['status'] as String? ?? "",
      type: json['type'] as String? ?? "",
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      protocol: json['protocol'] as String? ?? "",
      canEdit: json['can_edit'] as bool? ?? false,
      canCancel: json['can_cancel'] as bool? ?? false,
      inconcistency: json['inconcistency'] as String? ?? "",
      receipts: (json['receipts'] as List<dynamic>?)
              ?.map((e) =>
                  ResinRefundReceiptModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      destinationAccount: json['destination_account'] == null
          ? null
          : ResinBankAccountModel.fromJson(
              json['destination_account'] as Map<String, dynamic>),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$ResinRefundModelToJson(ResinRefundModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'request_date': instance.requestDate?.toIso8601String(),
      'requester': instance.requester,
      'status': instance.status,
      'type': instance.type,
      'value': instance.value,
      'protocol': instance.protocol,
      'description': instance.description,
      'can_edit': instance.canEdit,
      'can_cancel': instance.canCancel,
      'inconcistency': instance.inconcistency,
      'receipts': instance.receipts,
      'destination_account': instance.destinationAccount,
    };
