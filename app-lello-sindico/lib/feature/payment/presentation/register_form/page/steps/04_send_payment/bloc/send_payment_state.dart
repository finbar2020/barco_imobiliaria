import 'package:essentials/essentials.dart';

abstract class SendPaymentState {}

class SendPaymentEmptyState extends SendPaymentState {}

class SendPaymentLoadingState extends SendPaymentState {}

class SendPaymentSuccessState extends SendPaymentState {
  var value;
  SendPaymentSuccessState({required this.value});
}

class SendPaymentFailureState extends SendPaymentState {
  final Failure? error;
  SendPaymentFailureState({this.error});
}
