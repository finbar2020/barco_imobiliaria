import 'package:essentials/essentials.dart';

abstract class SendPaymentEvent {}

class SendPaymentEmptyEvent extends SendPaymentEvent {}

class SendPaymentLoadingEvent extends SendPaymentEvent {}

class SendPaymentSuccessEvent extends SendPaymentEvent {
  int? value;
  SendPaymentSuccessEvent({required this.value});
}

class SendPaymentFailureEvent extends SendPaymentEvent {
  final Failure error;
  SendPaymentFailureEvent({required this.error});
}
