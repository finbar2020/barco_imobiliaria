import 'package:lello/feature/payment/domain/entity/payment_installment_approver.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_ledger_account.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_supplier.dart';

class LancamentoEntity {
  final int? transactionId;
  final PaymentInstallmentSupplier? supplier;
  final List<PaymentInstallmentApprover>? approvers;
  PaymentInstallmentLedgerAccount? ledgerAccount;
  final String? registrationDate;
  final String? documentNumber;
  final double? totalValue;
  final String? dueDate;
  final String? status;
  final int? approverId1;
  final int? approverId2;
  final int? approverId3;
  final double? netValue;

  LancamentoEntity(
      {this.transactionId,
      this.approvers,
      this.ledgerAccount,
      this.supplier,
      this.registrationDate,
      this.documentNumber,
      this.totalValue,
      this.dueDate,
      this.status,
      this.approverId1,
      this.approverId2,
      this.approverId3,
      this.netValue,});

  LancamentoEntity copyWith({
    int? transactionId,
    PaymentInstallmentSupplier? supplier,
    List<PaymentInstallmentApprover>? approvers,
    PaymentInstallmentLedgerAccount? ledgerAccount,
    String? registrationDate,
    String? documentNumber,
    double? totalValue,
    String? dueDate,
    String? status,
    int? approverId1,
    int? approverId2,
    int? approverId3,
    double? netValue,
  }) {
    return LancamentoEntity(
      transactionId: transactionId ?? this.transactionId,
      supplier: supplier ?? this.supplier,
      approvers: approvers ?? this.approvers,
      status: status ?? this.status,
      ledgerAccount: ledgerAccount ?? this.ledgerAccount,
      registrationDate: registrationDate ?? this.registrationDate,
      documentNumber: documentNumber ?? this.documentNumber,
      totalValue: totalValue ?? this.totalValue,
      dueDate: dueDate ?? this.dueDate,
      approverId1: approverId1 ?? this.approverId1,
      approverId2: approverId2 ?? this.approverId2,
      approverId3: approverId3 ?? this.approverId3,
      netValue: netValue ?? this.netValue,
    );
  }
}
