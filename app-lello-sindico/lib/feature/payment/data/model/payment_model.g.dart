// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) => PaymentModel(
      id: json['id'] as String?,
      supplierIdentification: json['supplier_identification'] as String?,
      supplierName: json['supplier_name'] as String?,
      documentNumber: json['document_number'] as String?,
      paymentSource: json['payment_source'] as String?,
      totalValue: (json['total_value'] as num?)?.toDouble() ?? 0,
      expirationDate: json['expiration_date'] == null
          ? null
          : DateTime.parse(json['expiration_date'] as String),
      paymentHistory: json['payment_history'] as String?,
      accountId: json['account_id'] as String?,
      accountName: json['account_name'] as String?,
      installments: (json['installments'] as List<dynamic>?)
              ?.map((e) => e == null
                  ? null
                  : PaymentInstallmentsModel.fromJson(
                      e as Map<String, dynamic>))
              .toList() ??
          const [],
      paymentMethod: json['payment_method'] as String?,
      observation: json['observation'] as String?,
      status: json['status'] as String?,
      documentTypeId: json['document_type_id'] as String?,
      paymentIdentifier: json['payment_identifier'] as String?,
      approvalCurentReason: json['approval_curent_reason'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => e == null
                  ? null
                  : PaymentAttachmentsModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdDate: json['created_date'] == null
          ? null
          : DateTime.parse(json['created_date'] as String),
      canApprove: json['can_approve'] as bool?,
      approvalUsers: (json['approval_users'] as List<dynamic>?)
              ?.map((e) => e == null
                  ? null
                  : PaymentApprovalUsersModel.fromJson(
                      e as Map<String, dynamic>))
              .toList() ??
          const [],
      notificationContext: json['notification_context'] as String?,
    );

Map<String, dynamic> _$PaymentModelToJson(PaymentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'supplier_identification': instance.supplierIdentification,
      'supplier_name': instance.supplierName,
      'document_number': instance.documentNumber,
      'payment_source': instance.paymentSource,
      'total_value': instance.totalValue,
      'expiration_date': instance.expirationDate?.toIso8601String(),
      'payment_history': instance.paymentHistory,
      'account_id': instance.accountId,
      'account_name': instance.accountName,
      'installments': instance.installments,
      'payment_method': instance.paymentMethod,
      'observation': instance.observation,
      'status': instance.status,
      'document_type_id': instance.documentTypeId,
      'payment_identifier': instance.paymentIdentifier,
      'approval_curent_reason': instance.approvalCurentReason,
      'attachments': instance.attachments,
      'created_date': instance.createdDate?.toIso8601String(),
      'can_approve': instance.canApprove,
      'approval_users': instance.approvalUsers,
      'notification_context': instance.notificationContext,
    };
