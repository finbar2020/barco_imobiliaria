// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:intl/intl.dart';
import 'package:lello/feature/payment/domain/entity/payment_approval_users.dart';
import 'package:lello/feature/payment/domain/entity/payment_attachments.dart';
import 'package:lello/feature/payment/domain/entity/payment_installments.dart';
import 'package:lello/feature/payment/domain/entity/payment_source.dart';

class Payment {
  final String? id;
  final String? supplierIdentification;
  final String? supplierName;
  final String? documentNumber;
  final PaymentSource? paymentSource;
  final double totalValue;
  final DateTime? expirationDate;
  final String? paymentHistory;
  final String? accountId;
  final String? accountName;
  final bool hasInstallments;
  final bool equalInstallments;
  final List<PaymentInstallments> installments;
  final String? paymentMethod;
  final String? observation;
  final String? status;
  final String? documentTypeId;
  final String? paymentIdentifier;
  final String? approvalCurentReason;
  final List<ApprovalUsers> approvalUsers;
  final List<PaymentAttachments> attachments;
  String? notificationContext;

  final DateTime? createdDate;

  final bool? canApprove;

  Payment({
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
    this.hasInstallments = false,
    this.equalInstallments = true,
    this.installments = const [],
    this.paymentMethod,
    this.observation,
    this.status,
    this.documentTypeId,
    this.paymentIdentifier,
    this.approvalCurentReason,
    this.approvalUsers = const [],
    this.attachments = const [],
    this.createdDate,
    this.canApprove,
    this.notificationContext,
  });
  String? get totalValueFormat =>
      NumberFormat.currency(symbol: "R\$").format(totalValue);

  Payment copyWith({
    String? id,
    String? supplierIdentification,
    String? supplierName,
    String? documentNumber,
    PaymentSource? paymentSource,
    double? totalValue,
    DateTime? expirationDate,
    String? paymentHistory,
    String? accountId,
    String? accountName,
    bool? hasInstallments,
    bool? equalInstallments,
    List<PaymentInstallments>? installments,
    String? paymentMethod,
    String? observation,
    String? status,
    String? documentTypeId,
    String? paymentIdentifier,
    String? approvalCurentReason,
    List<ApprovalUsers>? approvalUsers,
    List<PaymentAttachments>? attachments,
    DateTime? createdDate,
    bool? canApprove,
  }) {
    return Payment(
      id: id ?? this.id,
      supplierIdentification:
          supplierIdentification ?? this.supplierIdentification,
      supplierName: supplierName ?? this.supplierName,
      documentNumber: documentNumber ?? this.documentNumber,
      paymentSource: paymentSource ?? this.paymentSource,
      totalValue: totalValue ?? this.totalValue,
      expirationDate: expirationDate ?? this.expirationDate,
      paymentHistory: paymentHistory ?? this.paymentHistory,
      accountId: accountId ?? this.accountId,
      accountName: accountName ?? this.accountName,
      hasInstallments: hasInstallments ?? this.hasInstallments,
      equalInstallments: equalInstallments ?? this.equalInstallments,
      installments: installments ?? this.installments,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      observation: observation ?? this.observation,
      status: status ?? this.status,
      documentTypeId: documentTypeId ?? this.documentTypeId,
      paymentIdentifier: paymentIdentifier ?? this.paymentIdentifier,
      approvalCurentReason: approvalCurentReason ?? this.approvalCurentReason,
      approvalUsers: approvalUsers ?? this.approvalUsers,
      attachments: attachments ?? this.attachments,
      createdDate: createdDate ?? this.createdDate,
      canApprove: canApprove ?? this.canApprove,
    );
  }
}
