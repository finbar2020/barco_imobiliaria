import 'package:essentials/functional/failure.dart';
import 'package:lello/feature/payment/domain/entity/contas_pagar.dart';

import '../../../domain/entity/payment.dart';

abstract class PaymentListState {}

class PaymentListEmptyState extends PaymentListState {}

class PaymentListLoadingState extends PaymentListState {}

class PaymentListPagingState extends PaymentListState {
  final List<Payment> data;

  PaymentListPagingState({required this.data});
}

class PaymentListSuccessState extends PaymentListState {
  final List<Payment> data;

  PaymentListSuccessState({required this.data});
}

class PaymentListFailureState extends PaymentListState {
  final Failure? error;

  PaymentListFailureState({this.error});
}

class PaymentContaPagarLoadingState extends PaymentListState {}

class PaymentContaPagarSuccessState extends PaymentListState {
  final List<ContasPagarEntity> data;
  PaymentContaPagarSuccessState({required this.data});
}

class PaymentContaPagarFailureState extends PaymentListState {
  final Failure? error;
  PaymentContaPagarFailureState({this.error});
}

class PaymentContaPagarEmptyState extends PaymentListState {}
