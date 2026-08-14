import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/payment/presentation/send_financial_department/bloc/payment_send_financial_department_event.dart';
import 'package:lello/feature/payment/presentation/send_financial_department/bloc/payment_send_financial_department_state.dart';

class PaymentSendFinancialDepartmentListBloc extends Bloc<
    PaymentSendFinancialDepartmentEvent, PaymentSendFinancialDepartmentState> {
  PaymentSendFinancialDepartmentListBloc()
      : super(PaymentSendFinancialDepartmentEmptyState()) {
    on<PaymentSendFinancialDepartmentEmptyEvent>(
        handlePaymentSendFinancialDepartmentEmptyEvent);
    on<PaymentSendFinancialDepartmentLoadingEvent>(
        handlePaymentSendFinancialDepartmentLoadingEvent);
    on<PaymentSendFinancialDepartmentPagingEvent>(
        handlePaymentSendFinancialDepartmentPagingEvent);
    on<PaymentSendFinancialDepartmentSuccessEvent>(
        handlePaymentSendFinancialDepartmentSuccessEvent);
    on<PaymentSendFinancialDepartmentFailureEvent>(
        handlePaymentSendFinancialDepartmentFailureEvent);
  }

  void handlePaymentSendFinancialDepartmentEmptyEvent(
          PaymentSendFinancialDepartmentEmptyEvent event, Emitter emit) =>
      emit(PaymentSendFinancialDepartmentEmptyState());

  void handlePaymentSendFinancialDepartmentLoadingEvent(
          PaymentSendFinancialDepartmentLoadingEvent event, Emitter emit) =>
      emit(PaymentSendFinancialDepartmentLoadingState());

  void handlePaymentSendFinancialDepartmentPagingEvent(
          PaymentSendFinancialDepartmentPagingEvent event, Emitter emit) =>
      emit(PaymentSendFinancialDepartmentEmptyState());

  void handlePaymentSendFinancialDepartmentSuccessEvent(
          PaymentSendFinancialDepartmentSuccessEvent event, Emitter emit) =>
      emit(PaymentSendFinancialDepartmentSuccessState());

  void handlePaymentSendFinancialDepartmentFailureEvent(
          PaymentSendFinancialDepartmentFailureEvent event, Emitter emit) =>
      emit(PaymentSendFinancialDepartmentFailureState(error: event.error));
}
