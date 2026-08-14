import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/payment/presentation/register/bloc/payment_registration_event.dart';
import 'package:lello/feature/payment/presentation/register/bloc/payment_registration_state.dart';

class PaymentSendDocumentBloc
    extends Bloc<PaymentSendDocumentEvent, PaymentSendDocumentState> {
  PaymentSendDocumentBloc() : super(PaymentRegistrationEmptyState()) {
    // Files
    on<PaymentSendDocumentEmptyEvent>(handlePaymentSendDocumentEmptyEvent);
    on<PaymentSendDocumentLoadingEvent>(handlePaymentSendDocumentLoadingEvent);
    on<PaymentSendDocumentFailureEvent>(handlePaymentSendDocumentFailureEvent);
    on<PaymentSendDocumentSuccessEvent>(handlePaymentSendDocumentSuccessEvent);
  }

  void handlePaymentSendDocumentEmptyEvent(PaymentSendDocumentEmptyEvent event,
      Emitter<PaymentSendDocumentState> emit) {
    emit(PaymentSendDocumentEmptyState());
  }

  void handlePaymentSendDocumentLoadingEvent(
      PaymentSendDocumentLoadingEvent event,
      Emitter<PaymentSendDocumentState> emit) {
    emit(PaymentSendDocumentLoadingState());
  }

  void handlePaymentSendDocumentFailureEvent(
      PaymentSendDocumentFailureEvent event,
      Emitter<PaymentSendDocumentState> emit) {
    emit(PaymentSendDocumentFailureState(error: event.error));
  }

  void handlePaymentSendDocumentSuccessEvent(
      PaymentSendDocumentSuccessEvent event,
      Emitter<PaymentSendDocumentState> emit) {
    emit(PaymentSendDocumentSuccessState(files: event.files));
  }
}
