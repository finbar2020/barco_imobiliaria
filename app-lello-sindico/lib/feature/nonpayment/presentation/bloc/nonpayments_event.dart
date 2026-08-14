import 'package:essentials/essentials.dart';
import 'package:lello/feature/nonpayment/domain/entity/nonpayments.dart';

abstract class NonPaymentsEvent {}

class NonPaymentsEmptyEvent extends NonPaymentsEvent {}

class NonPaymentsLoadingEvent extends NonPaymentsEvent {}

class NonPaymentsLoadFailedEvent extends NonPaymentsEvent {
  final Failure? error;
  NonPaymentsLoadFailedEvent({required this.error});
}

class NonPaymentsLoadedEvent extends NonPaymentsEvent {
  NonPayment payments;
  String condominiumName;

  NonPaymentsLoadedEvent(
      {required this.payments, required this.condominiumName});
}
