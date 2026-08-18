import 'package:equatable/equatable.dart';

abstract class PaymentListActionEvent extends Equatable {
  const PaymentListActionEvent();

  @override
  List<Object?> get props => [];
}

class PaymentListActionPressed extends PaymentListActionEvent {
  final String installmentId;
  const PaymentListActionPressed(this.installmentId);

  @override
  List<Object?> get props => [installmentId];
}

class PaymentListActionReset extends PaymentListActionEvent {}
