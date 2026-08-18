import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment_history_item.dart';

abstract class PaymentHistoryState {}

class PaymentHistoryEmptyState extends PaymentHistoryState {}

class PaymentHistoryLoadingState extends PaymentHistoryState {}

class PaymentHistoryPagingState extends PaymentHistoryState {}

class PaymentHistorySuccessState extends PaymentHistoryState {
  final List<PaymentHistoryItem> data;
  PaymentHistorySuccessState({required this.data});
}

class PaymentHistoryFailureState extends PaymentHistoryState {
  final Failure? error;
  PaymentHistoryFailureState({this.error});
}
