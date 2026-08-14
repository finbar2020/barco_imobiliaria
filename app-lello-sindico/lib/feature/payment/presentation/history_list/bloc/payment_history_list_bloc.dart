import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/payment/presentation/history_list/bloc/payment_history_list_event.dart';
import 'package:lello/feature/payment/presentation/history_list/bloc/payment_history_list_state.dart';

class PaymentHistoryListBloc
    extends Bloc<PaymentHistoryEvent, PaymentHistoryState> {
  PaymentHistoryListBloc() : super(PaymentHistoryEmptyState()) {
    on<PaymentHistoryEmptyEvent>(handlePaymentHistoryEmptyEvent);
    on<PaymentHistoryLoadingEvent>(handlePaymentHistoryLoadingEvent);
    on<PaymentHistoryPagingEvent>(handlePaymentHistoryPagingEvent);
    on<PaymentHistorySuccessEvent>(handlePaymentHistorySuccessEvent);
    on<PaymentHistoryFailureEvent>(handlePaymentHistoryFailureEvent);
  }

  void handlePaymentHistoryEmptyEvent(
          PaymentHistoryEmptyEvent event, Emitter emit) =>
      emit(PaymentHistoryEmptyState());

  void handlePaymentHistoryLoadingEvent(
          PaymentHistoryLoadingEvent event, Emitter emit) =>
      emit(PaymentHistoryLoadingState());

  void handlePaymentHistoryPagingEvent(
          PaymentHistoryPagingEvent event, Emitter emit) =>
      emit(PaymentHistoryEmptyState());

  void handlePaymentHistorySuccessEvent(
          PaymentHistorySuccessEvent event, Emitter emit) =>
      emit(PaymentHistorySuccessState(data: event.data));

  void handlePaymentHistoryFailureEvent(
          PaymentHistoryFailureEvent event, Emitter emit) =>
      emit(PaymentHistoryFailureState(error: event.error));
}
