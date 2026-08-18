import 'package:essentials/essentials.dart';

abstract class PaymentSendFinancialDepartmentState {}

class PaymentSendFinancialDepartmentEmptyState
    extends PaymentSendFinancialDepartmentState {}

class PaymentSendFinancialDepartmentLoadingState
    extends PaymentSendFinancialDepartmentState {}

class PaymentSendFinancialDepartmentSuccessState
    extends PaymentSendFinancialDepartmentState {
  PaymentSendFinancialDepartmentSuccessState();
}

class PaymentSendFinancialDepartmentFailureState
    extends PaymentSendFinancialDepartmentState {
  final Failure? error;
  PaymentSendFinancialDepartmentFailureState({this.error});
}
