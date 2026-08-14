import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_in_approval.dart';

abstract class PaymentListActionState extends Equatable {
  const PaymentListActionState();

  @override
  List<Object?> get props => [];
}

class PaymentListActionInitialState extends PaymentListActionState {
  const PaymentListActionInitialState();
}

class PaymentListActionLoadingState extends PaymentListActionState {
  const PaymentListActionLoadingState();
}

class PaymentListActionLoadedState extends PaymentListActionState {
  final PaymentInstallmentInApprovalEntity installment;

  const PaymentListActionLoadedState(this.installment);

  @override
  List<Object?> get props => [installment];
}

class PaymentListActionErrorState extends PaymentListActionState {
  final String message;

  const PaymentListActionErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
