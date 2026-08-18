import 'package:equatable/equatable.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_in_approval.dart';

abstract class PaymentListActionState extends Equatable {
  const PaymentListActionState();

  @override
  List<Object?> get props => [];
}

class PaymentListActionInitial extends PaymentListActionState {}

class PaymentListActionLoading extends PaymentListActionState {}

class PaymentListActionLoaded extends PaymentListActionState {
  final PaymentInstallmentInApprovalEntity installment;
  const PaymentListActionLoaded(this.installment);

  @override
  List<Object?> get props => [installment];
}

class PaymentListActionError extends PaymentListActionState {
  final String message;
  const PaymentListActionError(this.message);

  @override
  List<Object?> get props => [message];
}
