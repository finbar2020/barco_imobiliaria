import 'package:essentials/essentials.dart';
import 'package:lello/feature/account/domain/entity/account.dart';
import 'package:lello/feature/payment/domain/entity/payment_approval.dart';
import 'package:shared_features/shared_features.dart';

abstract class PaymentApprovalState {
  PaymentApproval? entity;
  List<Account> accounts;
  PaymentApprovalState(
    this.entity,
    this.accounts,
  );
}

class PaymentApprovalFormState extends PaymentApprovalState {
  PaymentApprovalFormState(
      {required PaymentApproval? entity, required List<Account> accounts})
      : super(entity, accounts);
}

class PaymentApprovalLoadingState extends PaymentApprovalFormState {
  PaymentApprovalLoadingState(
      {required PaymentApproval? entity, List<Account>? accounts})
      : super(entity: entity, accounts: accounts ?? []);
  factory PaymentApprovalLoadingState.empty() =>
      PaymentApprovalLoadingState(entity: null, accounts: null);
}

class PaymentApprovalLoadingFailedState extends PaymentApprovalFormState {
  final Failure? error;
  PaymentApprovalLoadingFailedState(
      {required PaymentApproval? entity, List<Account>? accounts, this.error})
      : super(entity: entity, accounts: accounts ?? []);
}

class PaymentApprovalRequestingCodeState extends PaymentApprovalState {
  final CodeValidationSource source;
  PaymentApprovalRequestingCodeState(
      {required PaymentApproval? entity,
      required List<Account> accounts,
      required this.source})
      : super(entity, accounts);
}

class PaymentApprovalCodeFailedState extends PaymentApprovalState {
  final Failure? error;
  PaymentApprovalCodeFailedState(
      {required PaymentApproval? entity, List<Account>? accounts, this.error})
      : super(entity, accounts ?? []);
}

class PaymentApprovalValidatingCodeState extends PaymentApprovalState {
  final CodeRequest? request;
  PaymentApprovalValidatingCodeState(
      {required PaymentApproval? entity, List<Account>? accounts, this.request})
      : super(entity, accounts ?? []);
}

class PaymentApprovalProgressState extends PaymentApprovalState {
  PaymentApprovalProgressState(
      {required PaymentApproval? entity, List<Account>? accounts})
      : super(entity, accounts ?? []);
}

class PaymentApprovalSucceededState extends PaymentApprovalState {
  PaymentApprovalSucceededState(
      {required PaymentApproval? entity, List<Account>? accounts})
      : super(entity, accounts ?? []);
}

class PaymentApprovalFailedState extends PaymentApprovalState {
  final Failure? error;
  PaymentApprovalFailedState(
      {required PaymentApproval? entity, List<Account>? accounts, this.error})
      : super(entity, accounts ?? []);
}

class PaymentApprovalRejectedState extends PaymentApprovalState {
  final Failure? error;
  PaymentApprovalRejectedState(
      {required PaymentApproval? entity, List<Account>? accounts, this.error})
      : super(entity, accounts ?? []);
}

class PaymentApprovalBiometricsFailureState extends PaymentApprovalState {
  PaymentApprovalBiometricsFailureState(
      {required PaymentApproval? entity, List<Account>? accounts})
      : super(entity, accounts ?? []);
}
