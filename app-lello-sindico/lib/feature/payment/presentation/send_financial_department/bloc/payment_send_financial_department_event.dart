import 'package:essentials/essentials.dart';

abstract class PaymentSendFinancialDepartmentEvent {}

class PaymentSendFinancialDepartmentEmptyEvent
    extends PaymentSendFinancialDepartmentEvent {}

class PaymentSendFinancialDepartmentLoadingEvent
    extends PaymentSendFinancialDepartmentEvent {}

class PaymentSendFinancialDepartmentPagingEvent
    extends PaymentSendFinancialDepartmentEvent {}

class PaymentSendFinancialDepartmentSuccessEvent
    extends PaymentSendFinancialDepartmentEvent {
  PaymentSendFinancialDepartmentSuccessEvent();
}

class PaymentSendFinancialDepartmentFailureEvent
    extends PaymentSendFinancialDepartmentEvent {
  final Failure? error;
  PaymentSendFinancialDepartmentFailureEvent({this.error});
}
