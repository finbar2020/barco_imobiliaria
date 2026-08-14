import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment_history_item.dart';

abstract class PaymentHistoryEvent extends Equatable {
  const PaymentHistoryEvent();

  @override
  List<Object?> get props => [];
}

class PaymentHistoryEmptyEvent extends PaymentHistoryEvent {
  const PaymentHistoryEmptyEvent();
}

class PaymentHistoryLoadingEvent extends PaymentHistoryEvent {
  const PaymentHistoryLoadingEvent();
}

class PaymentHistoryPagingEvent extends PaymentHistoryEvent {
  const PaymentHistoryPagingEvent();
}

class PaymentHistorySuccessEvent extends PaymentHistoryEvent {
  final List<PaymentHistoryItem> data;

  const PaymentHistorySuccessEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

class PaymentHistoryFailureEvent extends PaymentHistoryEvent {
  final Failure? error;

  const PaymentHistoryFailureEvent({this.error});

  @override
  List<Object?> get props => [error];
}
