import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_in_approval.dart';

abstract class PaymentPendencyEvent extends Equatable {
  const PaymentPendencyEvent();

  @override
  List<Object?> get props => [];
}

class PaymentPendencyEmptyEvent extends PaymentPendencyEvent {
  const PaymentPendencyEmptyEvent();
}

class PaymentCheckProfileLoadingEvent extends PaymentPendencyEvent {
  const PaymentCheckProfileLoadingEvent();
}

class PaymentCheckProfileSuccessEvent extends PaymentPendencyEvent {
  final bool success;

  const PaymentCheckProfileSuccessEvent({required this.success});

  @override
  List<Object?> get props => [success];
}

class PaymentCheckProfileFailureEvent extends PaymentPendencyEvent {
  final Failure? error;

  const PaymentCheckProfileFailureEvent({this.error});

  @override
  List<Object?> get props => [error];
}

class PaymentPendencyLoadingEvent extends PaymentPendencyEvent {
  const PaymentPendencyLoadingEvent();
}

class PaymentPendencyPagingEvent extends PaymentPendencyEvent {
  const PaymentPendencyPagingEvent();
}

class PaymentPendencySuccessEvent extends PaymentPendencyEvent {
  final List<PaymentInstallmentInApprovalEntity> data;

  const PaymentPendencySuccessEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

class PaymentPendencyFailureEvent extends PaymentPendencyEvent {
  final Failure? error;

  const PaymentPendencyFailureEvent({this.error});

  @override
  List<Object?> get props => [error];
}
