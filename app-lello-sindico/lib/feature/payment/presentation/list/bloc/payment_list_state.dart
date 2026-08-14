import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/contas_pagar.dart';

import '../../../domain/entity/payment.dart';

abstract class PaymentListState extends Equatable {
  const PaymentListState();

  @override
  List<Object?> get props => [];
}

class PaymentListEmptyState extends PaymentListState {
  const PaymentListEmptyState();
}

class PaymentListLoadingState extends PaymentListState {
  const PaymentListLoadingState();
}

class PaymentListPagingState extends PaymentListState {
  final List<Payment> data;

  const PaymentListPagingState({required this.data});

  @override
  List<Object?> get props => [data];
}

class PaymentListSuccessState extends PaymentListState {
  final List<Payment> data;

  const PaymentListSuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}

class PaymentListFailureState extends PaymentListState {
  final Failure? error;

  const PaymentListFailureState({this.error});

  @override
  List<Object?> get props => [error];
}

class PaymentContaPagarLoadingState extends PaymentListState {
  const PaymentContaPagarLoadingState();
}

class PaymentContaPagarSuccessState extends PaymentListState {
  final List<ContasPagarEntity> data;

  const PaymentContaPagarSuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}

class PaymentContaPagarFailureState extends PaymentListState {
  final Failure? error;

  const PaymentContaPagarFailureState({this.error});

  @override
  List<Object?> get props => [error];
}

class PaymentContaPagarEmptyState extends PaymentListState {
  const PaymentContaPagarEmptyState();
}
