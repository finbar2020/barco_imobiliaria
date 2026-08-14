import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment_history_item.dart';

abstract class PaymentHistoryState extends Equatable {
  const PaymentHistoryState();

  @override
  List<Object?> get props => [];
}

class PaymentHistoryEmptyState extends PaymentHistoryState {
  const PaymentHistoryEmptyState();
}

class PaymentHistoryLoadingState extends PaymentHistoryState {
  const PaymentHistoryLoadingState();
}

class PaymentHistoryPagingState extends PaymentHistoryState {
  const PaymentHistoryPagingState();
}

class PaymentHistorySuccessState extends PaymentHistoryState {
  final List<PaymentHistoryItem> data;

  const PaymentHistorySuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}

class PaymentHistoryFailureState extends PaymentHistoryState {
  final Failure? error;

  const PaymentHistoryFailureState({this.error});

  @override
  List<Object?> get props => [error];
}
