import 'package:lello/feature/payment/domain/entity/lancamento.dart';

class PaymentInstallmentInApprovalEntity {
  final int? installmentId;
  final String? dueDate;
  LancamentoEntity? lancamento;

  PaymentInstallmentInApprovalEntity(
      {this.installmentId, this.dueDate, this.lancamento});

  PaymentInstallmentInApprovalEntity copyWith(
      {int? installmentId, String? dueDate, LancamentoEntity? lancamento}) {
    return PaymentInstallmentInApprovalEntity(
        installmentId: installmentId ?? this.installmentId,
        dueDate: dueDate ?? this.dueDate,
        lancamento: lancamento ?? this.lancamento);
  }
}
