// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance.dart';
import 'package:lello/feature/payment/domain/entity/payment.dart';
import 'package:lello/feature/payment/domain/entity/payment_approval.dart';
import 'package:lello/feature/payment/domain/entity/supplier_ledger_accounts.dart';

abstract class PendencyEvent {}

class PendencyEmptyEvent extends PendencyEvent {}

class PendencyLoadingEvent extends PendencyEvent {}

class PendencySuccessEvent extends PendencyEvent {
  final Payment payment;
  PendencySuccessEvent({
    required this.payment,
  });
}

class PendencyLoadingFailedEvent extends PendencyEvent {
  final Failure? error;
  PendencyLoadingFailedEvent({this.error});
}

class PendencyBalanceLoadingEvent extends PendencyEvent {}

class PendencyBalanceSuccessEvent extends PendencyEvent {
  final CondominiumBalance balance;
  PendencyBalanceSuccessEvent({
    required this.balance,
  });
}

class PendencyBalanceFailedEvent extends PendencyEvent {
  final Failure? error;
  PendencyBalanceFailedEvent({this.error});
}

class PendencySupplierResetEvent extends PendencyEvent {}

class PendencySupplierLoadingEvent extends PendencyEvent {}

class PendencySupplierSuccessEvent extends PendencyEvent {
  final SupplierLedgerAccountsEntity supplierLedgerAccounts;
  PendencySupplierSuccessEvent({
    required this.supplierLedgerAccounts,
  });
}

class PendencySupplierFailedEvent extends PendencyEvent {
  final Failure? error;
  PendencySupplierFailedEvent({this.error});
}

class ApprovementPaymentPendencyEvent extends PendencyEvent {}

class ApprovementPaymentPendencySuccedEvent extends PendencyEvent {
  final PaymentApproval approval;
  ApprovementPaymentPendencySuccedEvent({
    required this.approval,
  });
}

class ApprovementPaymentPendencyFailedEvent extends PendencyEvent {
  final Failure? error;
  ApprovementPaymentPendencyFailedEvent({
    this.error,
  });
}

class UpdateLedgerAccountLoadingEvent extends PendencyEvent {}

class UpdateLedgerAccountFailureEvent extends PendencyEvent {
  final Failure? error;
  UpdateLedgerAccountFailureEvent({this.error});
}

class UpdateLedgerAccountSuccessEvent extends PendencyEvent {
  final bool success;
  UpdateLedgerAccountSuccessEvent({
    required this.success,
  });
}
