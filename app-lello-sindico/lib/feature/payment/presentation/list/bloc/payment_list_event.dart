import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/contas_pagar.dart';

import '../../../domain/entity/payment.dart';

abstract class PaymentListEvent extends Equatable {
  const PaymentListEvent();

  @override
  List<Object?> get props => [];
}

class PaymentListEmptyEvent extends PaymentListEvent {
  const PaymentListEmptyEvent();
}

class PaymentListLoadingEvent extends PaymentListEvent {
  const PaymentListLoadingEvent();
}

class PaymentListSuccessEvent extends PaymentListEvent {
  final List<Payment> data;

  const PaymentListSuccessEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

class PaymentListFailureEvent extends PaymentListEvent {
  final Failure? error;

  const PaymentListFailureEvent({this.error});

  @override
  List<Object?> get props => [error];
}

class PaymentContaPagarLoadingEvent extends PaymentListEvent {
  const PaymentContaPagarLoadingEvent();
}

class PaymentContaPagarSuccessEvent extends PaymentListEvent {
  final List<ContasPagarEntity> data;

  const PaymentContaPagarSuccessEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

class PaymentContaPagarFailureEvent extends PaymentListEvent {
  final Failure? error;

  const PaymentContaPagarFailureEvent({this.error});

  @override
  List<Object?> get props => [error];
}

class PaymentContaPagarEmptyEvent extends PaymentListEvent {
  const PaymentContaPagarEmptyEvent();
}
