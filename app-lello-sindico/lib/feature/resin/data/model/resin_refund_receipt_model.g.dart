// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resin_refund_receipt_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResinRefundReceiptModel _$ResinRefundReceiptModelFromJson(
        Map<String, dynamic> json) =>
    ResinRefundReceiptModel(
      id: json['id'] as String?,
      digitalDocument: json['digital_document'] == null
          ? null
          : ResinRefundDigitalDocumentModel.fromJson(
              json['digital_document'] as Map<String, dynamic>),
      sendDate: json['send_date'] == null
          ? null
          : DateTime.parse(json['send_date'] as String),
      receiptValue: (json['receipt_value'] as num?)?.toDouble(),
      receiptType: json['receipt_type'] as String?,
    );

Map<String, dynamic> _$ResinRefundReceiptModelToJson(
        ResinRefundReceiptModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'digital_document': instance.digitalDocument,
      'send_date': instance.sendDate?.toIso8601String(),
      'receipt_value': instance.receiptValue,
      'receipt_type': instance.receiptType,
    };
