import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/presentation/list/bloc/payment_list_event.dart';
import 'package:lello/feature/payment/presentation/list/bloc/payment_list_state.dart';

class PaymentListBloc extends Bloc<PaymentListEvent, PaymentListState> {
  PaymentListBloc() : super(PaymentListEmptyState()) {
    on<PaymentListEmptyEvent>(handlePaymentListEmptyEvent);
    on<PaymentListLoadingEvent>(handlePaymentListLoadingEvent);
    on<PaymentListSuccessEvent>(handlePaymentListSuccessEvent);
    on<PaymentListFailureEvent>(handlePaymentListFailureEvent);
    on<PaymentContaPagarLoadingEvent>(handlePaymentContaPagarLoadingEvent);
    on<PaymentContaPagarSuccessEvent>(handlePaymentContaPagarSuccessEvent);
    on<PaymentContaPagarFailureEvent>(handlePaymentContaPagarFailureEvent);
    on<PaymentContaPagarEmptyEvent>(handlePaymentContaPagarEmptyEvent);
  }

  void handlePaymentListEmptyEvent(PaymentListEmptyEvent event, Emitter emit) =>
      emit(PaymentListEmptyState());

  void handlePaymentListLoadingEvent(
          PaymentListLoadingEvent event, Emitter emit) =>
      emit(PaymentListLoadingState());

  void handlePaymentListSuccessEvent(
          PaymentListSuccessEvent event, Emitter emit) =>
      emit(PaymentListSuccessState(data: event.data));

  void handlePaymentListFailureEvent(
          PaymentListFailureEvent event, Emitter emit) =>
      emit(PaymentListFailureState(error: event.error));

  void handlePaymentContaPagarLoadingEvent(
          PaymentContaPagarLoadingEvent event, Emitter emit) =>
      emit(PaymentContaPagarLoadingState());

  void handlePaymentContaPagarSuccessEvent(
          PaymentContaPagarSuccessEvent event, Emitter emit) =>
      emit(PaymentContaPagarSuccessState(data: event.data));

  void handlePaymentContaPagarFailureEvent(
          PaymentContaPagarFailureEvent event, Emitter emit) =>
      emit(PaymentContaPagarFailureState(error: event.error));

  void handlePaymentContaPagarEmptyEvent(
          PaymentContaPagarEmptyEvent event, Emitter emit) =>
      emit(PaymentContaPagarEmptyState());
}
