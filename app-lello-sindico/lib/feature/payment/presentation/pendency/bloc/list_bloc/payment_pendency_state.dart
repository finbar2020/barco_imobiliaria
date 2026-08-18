import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/contas_pagar.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_in_approval.dart';

abstract class PaymentPendencyState {}

class PaymentPendencyEmptyState extends PaymentPendencyState {}

class PaymentCheckProfileLoadingState extends PaymentPendencyState {}

class PaymentCheckProfileSuccessState extends PaymentPendencyState {
  final bool success;
  PaymentCheckProfileSuccessState({required this.success});
}

class PaymentCheckProfileFailureState extends PaymentPendencyState {
  final Failure? error;
  PaymentCheckProfileFailureState({this.error});
}

class PaymentPendencyLoadingState extends PaymentPendencyState {}

class PaymentPendencyPagingState extends PaymentPendencyState {}

class PaymentPendencySuccessState extends PaymentPendencyState {
  final List<PaymentInstallmentInApprovalEntity> data;
  PaymentPendencySuccessState({required this.data});
}

class PaymentPendencyFailureState extends PaymentPendencyState {
  final Failure? error;
  PaymentPendencyFailureState({this.error});
}
