import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_in_approval.dart';

abstract class GetInstallmentsInApproval extends UseCase<
    List<PaymentInstallmentInApprovalEntity>, GetInstallmentsInApprovalParam> {}

class GetInstallmentsInApprovalParam {
  final String condominiumId;
  final String installmentId;
  final String dataCadastroDe;
  final String dataCadastroAte;
  final String? status;
  final String? filtrarAprovador;

  GetInstallmentsInApprovalParam({
    required this.condominiumId,
    required this.installmentId,
    required this.dataCadastroDe,
    required this.dataCadastroAte,
    this.status,
    this.filtrarAprovador,
  });
}
