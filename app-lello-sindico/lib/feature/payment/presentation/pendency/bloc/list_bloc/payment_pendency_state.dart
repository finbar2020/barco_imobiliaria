import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_in_approval.dart';

abstract class PaymentPendencyState extends Equatable {
  const PaymentPendencyState();

  @override
  List<Object?> get props => [];
}

class PaymentPendencyEmptyState extends PaymentPendencyState {
  const PaymentPendencyEmptyState();
}

class PaymentCheckProfileLoadingState extends PaymentPendencyState {
  const PaymentCheckProfileLoadingState();
}

class PaymentCheckProfileSuccessState extends PaymentPendencyState {
  final bool success;

  const PaymentCheckProfileSuccessState({required this.success});

  @override
  List<Object?> get props => [success];
}

class PaymentCheckProfileFailureState extends PaymentPendencyState {
  final Failure? error;

  const PaymentCheckProfileFailureState({this.error});

  @override
  List<Object?> get props => [error];
}

class PaymentPendencyLoadingState extends PaymentPendencyState {
  const PaymentPendencyLoadingState();
}

class PaymentPendencyPagingState extends PaymentPendencyState {
  const PaymentPendencyPagingState();
}

class PaymentPendencySuccessState extends PaymentPendencyState {
  final List<PaymentInstallmentInApprovalEntity> data;

  const PaymentPendencySuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}

class PaymentPendencyFailureState extends PaymentPendencyState {
  final Failure? error;

  const PaymentPendencyFailureState({this.error});

  @override
  List<Object?> get props => [error];
}
