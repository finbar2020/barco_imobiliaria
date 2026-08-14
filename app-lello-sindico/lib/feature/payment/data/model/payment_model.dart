// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:essentials/essentials.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/payment/data/model/payment_approval_users_model.dart';
import 'package:lello/feature/payment/data/model/payment_attachments_model.dart';
import 'package:lello/feature/payment/data/model/payment_installments_model.dart';
import 'package:lello/feature/payment/domain/entity/payment.dart';
import 'package:lello/feature/payment/domain/entity/payment_source.dart';

part 'payment_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PaymentModel {
  final String? id;
  final String? supplierIdentification;
  final String? supplierName;
  final String? documentNumber;
  final String? paymentSource;
  final double totalValue;
  final DateTime? expirationDate;
  final String? paymentHistory;
  final String? accountId;
  final String? accountName;
  final List<PaymentInstallmentsModel?> installments;
  final String? paymentMethod;
  final String? observation;
  final String? status;
  final String? documentTypeId;
  final String? paymentIdentifier;
  final String? approvalCurentReason;
  final List<PaymentAttachmentsModel?> attachments;
  final DateTime? createdDate;
  final bool? canApprove;
  final List<PaymentApprovalUsersModel?> approvalUsers;
  final String? notificationContext;

  PaymentModel({
    this.id,
    this.supplierIdentification,
    this.supplierName,
    this.documentNumber,
    this.paymentSource,
    this.totalValue = 0,
    this.expirationDate,
    this.paymentHistory,
    this.accountId,
    this.accountName,
    this.installments = const [],
    this.paymentMethod,
    this.observation,
    this.status,
    this.documentTypeId,
    this.paymentIdentifier,
    this.approvalCurentReason,
    this.attachments = const [],
    this.createdDate,
    this.canApprove,
    this.approvalUsers = const [],
    this.notificationContext,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);

  static PaymentModel? fromEntity(Payment? entity) => entity == null
      ? null
      : (PaymentModel(
          id: entity.id,
          supplierIdentification: entity.supplierIdentification,
          supplierName: entity.supplierName,
          documentNumber: entity.documentNumber,
          totalValue: entity.totalValue,
          expirationDate: entity.expirationDate,
          paymentHistory: entity.paymentHistory,
          accountId: entity.accountId,
          accountName: entity.accountName,
          paymentIdentifier: entity.paymentIdentifier,
          approvalCurentReason: entity.approvalCurentReason,
          installments: entity.installments
              .map((value) => PaymentInstallmentsModel.fromEntity(value))
              .toList(),
          approvalUsers: entity.approvalUsers
              .map((value) => PaymentApprovalUsersModel.fromEntity(value))
              .toList(),
          paymentMethod: entity.paymentMethod,
          observation: entity.observation,
          status: entity.status,
          paymentSource: enumToString(entity.paymentSource),
          documentTypeId: entity.documentTypeId,
          attachments: entity.attachments
              .map((value) => PaymentAttachmentsModel.fromEntity(value))
              .toList(),
          createdDate: entity.createdDate,
          canApprove: entity.canApprove,
          notificationContext: entity.notificationContext));

  Payment toEntity() => Payment(
        id: id,
        supplierIdentification: supplierIdentification,
        supplierName: supplierName,
        documentNumber: documentNumber,
        totalValue: totalValue,
        expirationDate: expirationDate,
        paymentHistory: paymentHistory,
        accountId: accountId,
        accountName: accountName,
        paymentIdentifier: paymentIdentifier,
        approvalCurentReason: approvalCurentReason,
        hasInstallments: installments.isNotEmpty,
        equalInstallments: installments.isNotEmpty &&
            installments.toSet().toList().length == 1,
        installments: installments.isNotEmpty
            ? installments.map((model) => model!.toEntity()).toList()
            : [],
        approvalUsers: approvalUsers.isNotEmpty
            ? approvalUsers.map((model) => model!.toEntity()).toList()
            : [],
        paymentMethod: paymentMethod,
        observation: observation,
        status: status,
        paymentSource: paymentSource == null
            ? PaymentSource.all
            : stringToEnum(PaymentSource.values, paymentSource!),
        documentTypeId: documentTypeId,
        attachments: attachments.isNotEmpty
            ? attachments.map((model) => model!.toEntity()).toList()
            : [],
        createdDate: createdDate,
        canApprove: canApprove,
        notificationContext: notificationContext,
      );
}
