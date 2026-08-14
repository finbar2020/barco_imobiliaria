import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/payment/presentation/widget/payment_search_supplier/bloc/payment_search_supplier_event.dart';
import 'package:lello/feature/payment/presentation/widget/payment_search_supplier/bloc/payment_search_supplier_state.dart';

class PaymentSearchSupplierListBloc
    extends Bloc<PaymentSearchSupplierEvent, PaymentSearchSupplierState> {
  PaymentSearchSupplierListBloc() : super(PaymentSearchSupplierEmptyState()) {
    on<PaymentSearchSupplierEmptyEvent>(handlePaymentSearchSupplierEmptyEvent);
    on<PaymentSearchSupplierLoadingEvent>(
        handlePaymentSearchSupplierLoadingEvent);
    on<PaymentSearchSupplierSuccessEvent>(
        handlePaymentSearchSupplierSuccessEvent);
    on<PaymentSearchSupplierFailureEvent>(
        handlePaymentSearchSupplierFailureEvent);
  }

  void handlePaymentSearchSupplierEmptyEvent(
          PaymentSearchSupplierEmptyEvent event, Emitter emit) =>
      emit(PaymentSearchSupplierEmptyState());

  void handlePaymentSearchSupplierLoadingEvent(
          PaymentSearchSupplierLoadingEvent event, Emitter emit) =>
      emit(PaymentSearchSupplierLoadingState());

  void handlePaymentSearchSupplierSuccessEvent(
          PaymentSearchSupplierSuccessEvent event, Emitter emit) =>
      emit(PaymentSearchSupplierSuccessState(value: event.supplier));

  void handlePaymentSearchSupplierFailureEvent(
          PaymentSearchSupplierFailureEvent event, Emitter emit) =>
      emit(PaymentSearchSupplierFailureState(error: event.error));
}
