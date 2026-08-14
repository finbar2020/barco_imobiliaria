import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance.dart';
import 'package:lello/feature/payment/domain/entity/payment.dart';
import 'package:lello/feature/payment/domain/entity/payment_approval.dart';
import 'package:lello/feature/payment/domain/entity/supplier_ledger_accounts.dart';

abstract class PendencyEvent extends Equatable {
  const PendencyEvent();

  @override
  List<Object?> get props => [];
}

class PendencyEmptyEvent extends PendencyEvent {
  const PendencyEmptyEvent();
}

class PendencyLoadingEvent extends PendencyEvent {
  const PendencyLoadingEvent();
}

class PendencySuccessEvent extends PendencyEvent {
  final Payment payment;

  const PendencySuccessEvent({required this.payment});

  @override
  List<Object?> get props => [payment];
}

class PendencyLoadingFailedEvent extends PendencyEvent {
  final Failure? error;

  const PendencyLoadingFailedEvent({this.error});

  @override
  List<Object?> get props => [error];
}

class PendencyBalanceLoadingEvent extends PendencyEvent {
  const PendencyBalanceLoadingEvent();
}

class PendencyBalanceSuccessEvent extends PendencyEvent {
  final CondominiumBalance balance;

  const PendencyBalanceSuccessEvent({required this.balance});

  @override
  List<Object?> get props => [balance];
}

class PendencyBalanceFailedEvent extends PendencyEvent {
  final Failure? error;

  const PendencyBalanceFailedEvent({this.error});

  @override
  List<Object?> get props => [error];
}

class PendencySupplierResetEvent extends PendencyEvent {
  const PendencySupplierResetEvent();
}

class PendencySupplierLoadingEvent extends PendencyEvent {
  const PendencySupplierLoadingEvent();
}

class PendencySupplierSuccessEvent extends PendencyEvent {
  final SupplierLedgerAccountsEntity supplierLedgerAccounts;

  const PendencySupplierSuccessEvent({required this.supplierLedgerAccounts});

  @override
  List<Object?> get props => [supplierLedgerAccounts];
}

class PendencySupplierFailedEvent extends PendencyEvent {
  final Failure? error;

  const PendencySupplierFailedEvent({this.error});

  @override
  List<Object?> get props => [error];
}

class ApprovementPaymentPendencyEvent extends PendencyEvent {
  const ApprovementPaymentPendencyEvent();
}

class ApprovementPaymentPendencySuccedEvent extends PendencyEvent {
  final PaymentApproval approval;

  const ApprovementPaymentPendencySuccedEvent({required this.approval});

  @override
  List<Object?> get props => [approval];
}

class ApprovementPaymentPendencyFailedEvent extends PendencyEvent {
  final Failure? error;

  const ApprovementPaymentPendencyFailedEvent({this.error});

  @override
  List<Object?> get props => [error];
}

class UpdateLedgerAccountLoadingEvent extends PendencyEvent {
  const UpdateLedgerAccountLoadingEvent();
}

class UpdateLedgerAccountFailureEvent extends PendencyEvent {
  final Failure? error;

  const UpdateLedgerAccountFailureEvent({this.error});

  @override
  List<Object?> get props => [error];
}

class UpdateLedgerAccountSuccessEvent extends PendencyEvent {
  final bool success;

  const UpdateLedgerAccountSuccessEvent({required this.success});

  @override
  List<Object?> get props => [success];
}
