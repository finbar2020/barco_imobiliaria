import 'package:essentials/essentials.dart';

abstract class PaymentSendFinancialDepartmentState extends Equatable {
  const PaymentSendFinancialDepartmentState();

  @override
  List<Object?> get props => [];
}

class PaymentSendFinancialDepartmentEmptyState
    extends PaymentSendFinancialDepartmentState {
  const PaymentSendFinancialDepartmentEmptyState();
}

class PaymentSendFinancialDepartmentLoadingState
    extends PaymentSendFinancialDepartmentState {
  const PaymentSendFinancialDepartmentLoadingState();
}

class PaymentSendFinancialDepartmentSuccessState
    extends PaymentSendFinancialDepartmentState {
  const PaymentSendFinancialDepartmentSuccessState();
}

class PaymentSendFinancialDepartmentFailureState
    extends PaymentSendFinancialDepartmentState {
  final Failure? error;

  const PaymentSendFinancialDepartmentFailureState({this.error});

  @override
  List<Object?> get props => [error];
}
