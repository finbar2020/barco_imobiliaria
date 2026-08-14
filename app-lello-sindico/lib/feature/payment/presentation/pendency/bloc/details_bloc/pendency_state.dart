import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance.dart';
import 'package:lello/feature/payment/domain/entity/payment.dart';
import 'package:lello/feature/payment/domain/entity/payment_approval.dart';
import 'package:lello/feature/payment/domain/entity/supplier_ledger_accounts.dart';

abstract class PendencyState extends Equatable {
  const PendencyState();

  @override
  List<Object?> get props => [];
}

class PendencyEmptyState extends PendencyState {
  const PendencyEmptyState();
}

class PendencyLoadingState extends PendencyState {
  const PendencyLoadingState();
}

class PendencySuccessState extends PendencyState {
  final Payment payment;

  const PendencySuccessState({required this.payment});

  @override
  List<Object?> get props => [payment];
}

class PendencyLoadingFailedState extends PendencyState {
  final Failure? error;

  const PendencyLoadingFailedState({this.error});

  @override
  List<Object?> get props => [error];
}

class PendencyBalanceLoadingState extends PendencyState {
  const PendencyBalanceLoadingState();
}

class PendencyBalanceSuccessState extends PendencyState {
  final CondominiumBalance balance;

  const PendencyBalanceSuccessState({required this.balance});

  @override
  List<Object?> get props => [balance];
}

class PendencyBalanceFailedState extends PendencyState {
  final Failure? error;

  const PendencyBalanceFailedState({this.error});

  @override
  List<Object?> get props => [error];
}

class PendencySupplierResetState extends PendencyState {
  const PendencySupplierResetState();
}

class PendencySupplierLoadingState extends PendencyState {
  const PendencySupplierLoadingState();
}

class PendencySupplierSuccessState extends PendencyState {
  final SupplierLedgerAccountsEntity supplierLedgerAccounts;

  const PendencySupplierSuccessState({required this.supplierLedgerAccounts});

  @override
  List<Object?> get props => [supplierLedgerAccounts];
}

class PendencySupplierFailedState extends PendencyState {
  final Failure? error;

  const PendencySupplierFailedState({this.error});

  @override
  List<Object?> get props => [error];
}

class ApprovementPaymentPendencyState extends PendencyState {
  const ApprovementPaymentPendencyState();
}

class ApprovementPaymentPendencySuccedState extends PendencyState {
  final PaymentApproval approval;

  const ApprovementPaymentPendencySuccedState({required this.approval});

  @override
  List<Object?> get props => [approval];
}

class ApprovementPaymentPendencyFailedState extends PendencyState {
  final Failure? error;

  const ApprovementPaymentPendencyFailedState({this.error});

  @override
  List<Object?> get props => [error];
}

class UpdateLedgerAccountLoadingState extends PendencyState {
  const UpdateLedgerAccountLoadingState();
}

class UpdateLedgerAccountFailureState extends PendencyState {
  final Failure? error;

  const UpdateLedgerAccountFailureState({this.error});

  @override
  List<Object?> get props => [error];
}

class UpdateLedgerAccountSuccessState extends PendencyState {
  final bool success;

  const UpdateLedgerAccountSuccessState({required this.success});

  @override
  List<Object?> get props => [success];
}
