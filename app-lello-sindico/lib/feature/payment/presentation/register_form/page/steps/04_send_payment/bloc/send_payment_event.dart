import 'package:essentials/essentials.dart';

abstract class SendPaymentEvent extends Equatable {
  const SendPaymentEvent();

  @override
  List<Object?> get props => [];
}

class SendPaymentEmptyEvent extends SendPaymentEvent {
  const SendPaymentEmptyEvent();
}

class SendPaymentLoadingEvent extends SendPaymentEvent {
  const SendPaymentLoadingEvent();
}

class SendPaymentSuccessEvent extends SendPaymentEvent {
  final int? value;

  const SendPaymentSuccessEvent({required this.value});

  @override
  List<Object?> get props => [value];
}

class SendPaymentFailureEvent extends SendPaymentEvent {
  final Failure error;

  const SendPaymentFailureEvent({required this.error});

  @override
  List<Object?> get props => [error];
}
