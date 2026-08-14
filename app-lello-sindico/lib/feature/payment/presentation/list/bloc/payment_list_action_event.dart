import 'package:essentials/essentials.dart';

abstract class PaymentListActionEvent extends Equatable {
  const PaymentListActionEvent();

  @override
  List<Object?> get props => [];
}

class PaymentListActionPressedEvent extends PaymentListActionEvent {
  final String installmentId;

  const PaymentListActionPressedEvent(this.installmentId);

  @override
  List<Object?> get props => [installmentId];
}

class PaymentListActionResetEvent extends PaymentListActionEvent {
  const PaymentListActionResetEvent();
}
