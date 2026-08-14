import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/04_send_payment/bloc/send_payment_event.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/04_send_payment/bloc/send_payment_state.dart';

class SendPaymentBloc extends Bloc<SendPaymentEvent, SendPaymentState> {
  SendPaymentBloc() : super(SendPaymentEmptyState()) {
    on<SendPaymentEmptyEvent>(handleSendPaymentEmptyEvent);
    on<SendPaymentLoadingEvent>(handleSendPaymentLoadingEvent);
    on<SendPaymentSuccessEvent>(handleSendPaymentSuccessEvent);
    on<SendPaymentFailureEvent>(handleSendPaymentFailureEvent);
  }

  void handleSendPaymentEmptyEvent(SendPaymentEmptyEvent event, Emitter emit) =>
      emit(SendPaymentEmptyState());

  void handleSendPaymentLoadingEvent(
          SendPaymentLoadingEvent event, Emitter emit) =>
      emit(SendPaymentLoadingState());

  void handleSendPaymentSuccessEvent(
          SendPaymentSuccessEvent event, Emitter emit) =>
      emit(SendPaymentSuccessState(value: event.value));

  void handleSendPaymentFailureEvent(
          SendPaymentFailureEvent event, Emitter emit) =>
      emit(SendPaymentFailureState(error: event.error));
}
