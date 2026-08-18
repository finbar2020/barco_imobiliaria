import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/contas_pagar.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_in_approval.dart';
import 'package:lello/feature/payment/domain/entity/supplier_data_entity.dart';

abstract class PaymentPendencyEvent {}

class PaymentPendencyEmptyEvent extends PaymentPendencyEvent {}

class PaymentCheckProfileLoadingEvent extends PaymentPendencyEvent {}

class PaymentCheckProfileSuccessEvent extends PaymentPendencyEvent {
  final bool success;
  PaymentCheckProfileSuccessEvent({required this.success});
}

class PaymentCheckProfileFailureEvent extends PaymentPendencyEvent {
  final Failure? error;
  PaymentCheckProfileFailureEvent({this.error});
}

class PaymentPendencyLoadingEvent extends PaymentPendencyEvent {}

class PaymentPendencyPagingEvent extends PaymentPendencyEvent {}

class PaymentPendencySuccessEvent extends PaymentPendencyEvent {
  final List<PaymentInstallmentInApprovalEntity> data;
  PaymentPendencySuccessEvent({required this.data});
}

class PaymentPendencyFailureEvent extends PaymentPendencyEvent {
  final Failure? error;
  PaymentPendencyFailureEvent({this.error});
}
