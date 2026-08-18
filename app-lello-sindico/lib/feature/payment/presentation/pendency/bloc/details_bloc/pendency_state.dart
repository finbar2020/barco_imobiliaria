// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:lello/feature/condominium/domain/entity/condominium_balance.dart';
import 'package:lello/feature/payment/domain/entity/payment.dart';
import 'package:lello/feature/payment/domain/entity/payment_approval.dart';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/supplier_ledger_accounts.dart';

abstract class PendencyState {}

class PendencyEmptyState extends PendencyState {}

class PendencyLoadingState extends PendencyState {}

class PendencySuccessState extends PendencyState {
  final Payment payment;
  PendencySuccessState({
    required this.payment,
  });
}

class PendencyLoadingFailedState extends PendencyState {
  final Failure? error;
  PendencyLoadingFailedState({this.error});
}

class PendencyBalanceLoadingState extends PendencyState {}

class PendencyBalanceSuccessState extends PendencyState {
  final CondominiumBalance balance;
  PendencyBalanceSuccessState({
    required this.balance,
  });
}

class PendencyBalanceFailedState extends PendencyState {
  final Failure? error;
  PendencyBalanceFailedState({this.error});
}

class PendencySupplierResetState extends PendencyState {}

class PendencySupplierLoadingState extends PendencyState {}

class PendencySupplierSuccessState extends PendencyState {
  final SupplierLedgerAccountsEntity supplierLedgerAccounts;
  PendencySupplierSuccessState({
    required this.supplierLedgerAccounts,
  });
}

class PendencySupplierFailedState extends PendencyState {
  final Failure? error;
  PendencySupplierFailedState({this.error});
}

class ApprovementPaymentPendencyState extends PendencyState {}

class ApprovementPaymentPendencySuccedState extends PendencyState {
  final PaymentApproval approval;
  ApprovementPaymentPendencySuccedState({
    required this.approval,
  });
}

class ApprovementPaymentPendencyFailedState extends PendencyState {
  final Failure? error;
  ApprovementPaymentPendencyFailedState({
    this.error,
  });
}

class UpdateLedgerAccountLoadingState extends PendencyState {}

class UpdateLedgerAccountFailureState extends PendencyState {
  final Failure? error;
  UpdateLedgerAccountFailureState({this.error});
}

class UpdateLedgerAccountSuccessState extends PendencyState {
  final bool success;
  UpdateLedgerAccountSuccessState({required this.success});
}
