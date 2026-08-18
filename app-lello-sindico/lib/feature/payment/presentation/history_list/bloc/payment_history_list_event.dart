import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment_history_item.dart';

abstract class PaymentHistoryEvent {}

class PaymentHistoryEmptyEvent extends PaymentHistoryEvent {}

class PaymentHistoryLoadingEvent extends PaymentHistoryEvent {}

class PaymentHistoryPagingEvent extends PaymentHistoryEvent {}

class PaymentHistorySuccessEvent extends PaymentHistoryEvent {
  final List<PaymentHistoryItem> data;
  PaymentHistorySuccessEvent({required this.data});
}

class PaymentHistoryFailureEvent extends PaymentHistoryEvent {
  final Failure? error;
  PaymentHistoryFailureEvent({this.error});
}
