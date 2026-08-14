import 'package:essentials/essentials.dart';
import 'package:lello/feature/nonpayment/domain/entity/nonpayments.dart';

abstract class NonPaymentsState {}

class NonPaymentsEmptyState extends NonPaymentsState {}

class NonPaymentsLoadingState extends NonPaymentsState {}

class NonPaymentsLoadFailedState extends NonPaymentsState {
  final Failure? error;
  NonPaymentsLoadFailedState({required this.error});
}

class NonPaymentsLoadedState extends NonPaymentsState {
  NonPayment payments;
  String condominiumName;
  NonPaymentsLoadedState(
      {required this.payments, required this.condominiumName});
}
