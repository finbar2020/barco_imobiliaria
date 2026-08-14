// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_history_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentHistoryItemModel _$PaymentHistoryItemModelFromJson(
        Map<String, dynamic> json) =>
    PaymentHistoryItemModel()
      ..documentId = (json['document_id'] as num?)?.toInt()
      ..fileName = json['file_name'] as String?
      ..releaseId = json['release_id'] as String?
      ..reference = json['reference'] as String?
      ..processingStatus = json['processing_status'] as String?
      ..inclusionDate = json['inclusion_date'] == null
          ? null
          : DateTime.parse(json['inclusion_date'] as String)
      ..totalValue = (json['total_value'] as num?)?.toDouble()
      ..supplierName = json['supplier_name'] as String?
      ..installments = (json['installments'] as num?)?.toInt()
      ..documentOrigin = json['document_origin'] as String?;

Map<String, dynamic> _$PaymentHistoryItemModelToJson(
        PaymentHistoryItemModel instance) =>
    <String, dynamic>{
      'document_id': instance.documentId,
      'file_name': instance.fileName,
      'release_id': instance.releaseId,
      'reference': instance.reference,
      'processing_status': instance.processingStatus,
      'inclusion_date': instance.inclusionDate?.toIso8601String(),
      'total_value': instance.totalValue,
      'supplier_name': instance.supplierName,
      'installments': instance.installments,
      'document_origin': instance.documentOrigin,
    };
