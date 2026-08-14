import 'package:essentials/essentials.dart';
import 'package:lello/feature/account/domain/entity/account.dart';
import 'package:lello/feature/payment/domain/entity/payment_approval.dart';
import 'package:shared_features/shared_features.dart';

abstract class PaymentApprovalState extends Equatable {
  final PaymentApproval? entity;
  final List<Account> accounts;

  const PaymentApprovalState({
    this.entity,
    this.accounts = const [],
  });

  @override
  List<Object?> get props => [entity, accounts];
}

class PaymentApprovalFormState extends PaymentApprovalState {
  const PaymentApprovalFormState({
    required super.entity,
    required super.accounts,
  });
}

class PaymentApprovalLoadingState extends PaymentApprovalFormState {
  const PaymentApprovalLoadingState({
    required super.entity,
    super.accounts = const [],
  });

  factory PaymentApprovalLoadingState.empty() =>
      const PaymentApprovalLoadingState(entity: null);
}

class PaymentApprovalLoadingFailedState extends PaymentApprovalFormState {
  final Failure? error;

  const PaymentApprovalLoadingFailedState({
    required super.entity,
    super.accounts = const [],
    this.error,
  });

  @override
  List<Object?> get props => [entity, accounts, error];
}

class PaymentApprovalRequestingCodeState extends PaymentApprovalState {
  final CodeValidationSource source;

  const PaymentApprovalRequestingCodeState({
    required super.entity,
    required super.accounts,
    required this.source,
  });

  @override
  List<Object?> get props => [entity, accounts, source];
}

class PaymentApprovalCodeFailedState extends PaymentApprovalState {
  final Failure? error;

  const PaymentApprovalCodeFailedState({
    required super.entity,
    super.accounts = const [],
    this.error,
  });

  @override
  List<Object?> get props => [entity, accounts, error];
}

class PaymentApprovalValidatingCodeState extends PaymentApprovalState {
  final CodeRequest? request;

  const PaymentApprovalValidatingCodeState({
    required super.entity,
    super.accounts = const [],
    this.request,
  });

  @override
  List<Object?> get props => [entity, accounts, request];
}

class PaymentApprovalProgressState extends PaymentApprovalState {
  const PaymentApprovalProgressState({
    required super.entity,
    super.accounts = const [],
  });
}

class PaymentApprovalSucceededState extends PaymentApprovalState {
  const PaymentApprovalSucceededState({
    required super.entity,
    super.accounts = const [],
  });
}

class PaymentApprovalFailedState extends PaymentApprovalState {
  final Failure? error;

  const PaymentApprovalFailedState({
    required super.entity,
    super.accounts = const [],
    this.error,
  });

  @override
  List<Object?> get props => [entity, accounts, error];
}

class PaymentApprovalRejectedState extends PaymentApprovalState {
  final Failure? error;

  const PaymentApprovalRejectedState({
    required super.entity,
    super.accounts = const [],
    this.error,
  });

  @override
  List<Object?> get props => [entity, accounts, error];
}

class PaymentApprovalBiometricsFailureState extends PaymentApprovalState {
  const PaymentApprovalBiometricsFailureState({
    required super.entity,
    super.accounts = const [],
  });
}
