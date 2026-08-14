import 'package:essentials/essentials.dart';

abstract class SendPaymentState extends Equatable {
  const SendPaymentState();

  @override
  List<Object?> get props => [];
}

class SendPaymentEmptyState extends SendPaymentState {
  const SendPaymentEmptyState();
}

class SendPaymentLoadingState extends SendPaymentState {
  const SendPaymentLoadingState();
}

class SendPaymentSuccessState extends SendPaymentState {
  final dynamic value;

  const SendPaymentSuccessState({required this.value});

  @override
  List<Object?> get props => [value];
}

class SendPaymentFailureState extends SendPaymentState {
  final Failure? error;

  const SendPaymentFailureState({this.error});

  @override
  List<Object?> get props => [error];
}
