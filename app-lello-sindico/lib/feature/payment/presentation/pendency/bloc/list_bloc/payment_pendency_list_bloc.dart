import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/list_bloc/payment_pendency_event.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/list_bloc/payment_pendency_state.dart';

class PaymentPendencyListBloc
    extends Bloc<PaymentPendencyEvent, PaymentPendencyState> {
  PaymentPendencyListBloc() : super(PaymentPendencyEmptyState()) {
    on<PaymentPendencyEmptyEvent>(handlePaymentPendencyEmptyEvent);
    on<PaymentCheckProfileLoadingEvent>(handleCheckProfileLoadingEvent);
    on<PaymentCheckProfileSuccessEvent>(handleCheckProfileSuccessEvent);
    on<PaymentCheckProfileFailureEvent>(handleCheckProfileFailureEvent);
    on<PaymentPendencyLoadingEvent>(handlePaymentPendencyLoadingEvent);
    on<PaymentPendencyPagingEvent>(handlePaymentPendencyPagingEvent);
    on<PaymentPendencySuccessEvent>(handlePaymentPendencySuccessEvent);
    on<PaymentPendencyFailureEvent>(handlePaymentPendencyFailureEvent);
  }

  void handlePaymentPendencyEmptyEvent(
          PaymentPendencyEmptyEvent event, Emitter emit) =>
      emit(PaymentPendencyEmptyState());

  void handleCheckProfileLoadingEvent(
          PaymentCheckProfileLoadingEvent event, Emitter emit) =>
      emit(PaymentCheckProfileLoadingState());

  void handleCheckProfileSuccessEvent(
          PaymentCheckProfileSuccessEvent event, Emitter emit) =>
      emit(PaymentCheckProfileSuccessState(success: event.success));

  void handleCheckProfileFailureEvent(
          PaymentCheckProfileFailureEvent event, Emitter emit) =>
      emit(PaymentCheckProfileFailureState(error: event.error));

  void handlePaymentPendencyLoadingEvent(
          PaymentPendencyLoadingEvent event, Emitter emit) =>
      emit(PaymentPendencyLoadingState());

  void handlePaymentPendencyPagingEvent(
          PaymentPendencyPagingEvent event, Emitter emit) =>
      emit(PaymentPendencyEmptyState());

  void handlePaymentPendencySuccessEvent(
          PaymentPendencySuccessEvent event, Emitter emit) =>
      emit(PaymentPendencySuccessState(data: event.data));

  void handlePaymentPendencyFailureEvent(
          PaymentPendencyFailureEvent event, Emitter emit) =>
      emit(PaymentPendencyFailureState(error: event.error));
}
