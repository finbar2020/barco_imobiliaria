import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment_approval.dart';

abstract class PaymentApprovalEvent extends Equatable {
  const PaymentApprovalEvent();

  @override
  List<Object?> get props => [];
}

class PaymentApprovalLoadDataEvent extends PaymentApprovalEvent {
  const PaymentApprovalLoadDataEvent();
}

class PaymentApprovalRevertCodeEvent extends PaymentApprovalEvent {
  const PaymentApprovalRevertCodeEvent();
}

class PaymentApprovalRequestValidationCodeEvent extends PaymentApprovalEvent {
  final String value;
  final CodeValidationSource source;

  const PaymentApprovalRequestValidationCodeEvent({
    required this.value,
    required this.source,
  });

  @override
  List<Object?> get props => [value, source];
}

class PaymentApprovalSendEvent extends PaymentApprovalEvent {
  final PaymentApproval approval;

  const PaymentApprovalSendEvent({required this.approval});

  @override
  List<Object?> get props => [approval];
}
