import 'package:lello/feature/payment/domain/entity/payment_approval_type.dart';

class PaymentApproval {
  String? id;
  String? paymentId;
  PaymentApprovalType? type;
  String? accountId;
  String? paymentHistory;
  String? reason;
  PaymentApproval({
    this.id = "",
    this.paymentId,
    this.type = PaymentApprovalType.approve,
    this.accountId,
    this.paymentHistory,
    this.reason,
  });
}
