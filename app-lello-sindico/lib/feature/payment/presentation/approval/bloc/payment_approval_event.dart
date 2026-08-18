import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment_approval.dart';

abstract class PaymentApprovalEvent {}

class PaymentApprovalLoadDataEvent extends PaymentApprovalEvent {}

class PaymentApprovalRevertCodeEvent extends PaymentApprovalEvent {}

class PaymentApprovalRequestValidationCodeEvent extends PaymentApprovalEvent {
  final String value;
  final CodeValidationSource source;

  PaymentApprovalRequestValidationCodeEvent(
      {required this.value, required this.source});
}

class PaymentApprovalSendEvent extends PaymentApprovalEvent {
  final PaymentApproval approval;
  PaymentApprovalSendEvent({required this.approval});
}
