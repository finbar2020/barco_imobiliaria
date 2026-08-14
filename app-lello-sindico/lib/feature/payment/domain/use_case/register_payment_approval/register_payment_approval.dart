import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment_approval.dart';

abstract class RegisterPaymentApproval
    extends UseCase<PaymentApproval, RegisterPaymentApprovalParam> {}

class RegisterPaymentApprovalParam {
  final String condominiumId;
  final PaymentApproval approval;
  RegisterPaymentApprovalParam(
      {required this.condominiumId, required this.approval});
}
