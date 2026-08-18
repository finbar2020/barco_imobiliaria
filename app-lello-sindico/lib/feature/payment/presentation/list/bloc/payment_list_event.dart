import 'package:essentials/functional/failure.dart';
import 'package:lello/feature/payment/domain/entity/contas_pagar.dart';

import '../../../domain/entity/payment.dart';

abstract class PaymentListEvent {}

class PaymentListEmptyEvent extends PaymentListEvent {}

class PaymentListLoadingEvent extends PaymentListEvent {}

class PaymentListSuccessEvent extends PaymentListEvent {
  final List<Payment> data;

  PaymentListSuccessEvent({required this.data});
}

class PaymentListFailureEvent extends PaymentListEvent {
  final Failure? error;

  PaymentListFailureEvent({this.error});
}

class PaymentContaPagarLoadingEvent extends PaymentListEvent {}

class PaymentContaPagarSuccessEvent extends PaymentListEvent {
  final List<ContasPagarEntity> data;
  PaymentContaPagarSuccessEvent({required this.data});
}

class PaymentContaPagarFailureEvent extends PaymentListEvent {
  final Failure? error;
  PaymentContaPagarFailureEvent({this.error});
}

class PaymentContaPagarEmptyEvent extends PaymentListEvent {}
