import 'package:essentials/essentials.dart';

abstract class PaymentSendFinancialDepartmentEvent extends Equatable {
  const PaymentSendFinancialDepartmentEvent();

  @override
  List<Object?> get props => [];
}

class PaymentSendFinancialDepartmentEmptyEvent
    extends PaymentSendFinancialDepartmentEvent {
  const PaymentSendFinancialDepartmentEmptyEvent();
}

class PaymentSendFinancialDepartmentLoadingEvent
    extends PaymentSendFinancialDepartmentEvent {
  const PaymentSendFinancialDepartmentLoadingEvent();
}

class PaymentSendFinancialDepartmentPagingEvent
    extends PaymentSendFinancialDepartmentEvent {
  const PaymentSendFinancialDepartmentPagingEvent();
}

class PaymentSendFinancialDepartmentSuccessEvent
    extends PaymentSendFinancialDepartmentEvent {
  const PaymentSendFinancialDepartmentSuccessEvent();
}

class PaymentSendFinancialDepartmentFailureEvent
    extends PaymentSendFinancialDepartmentEvent {
  final Failure? error;

  const PaymentSendFinancialDepartmentFailureEvent({this.error});

  @override
  List<Object?> get props => [error];
}
