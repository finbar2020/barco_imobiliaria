import 'dart:io';

import 'package:essentials/essentials.dart';

abstract class PaymentSendDocumentState extends Equatable {
  const PaymentSendDocumentState();

  @override
  List<Object?> get props => [];
}

class PaymentSendDocumentEmptyState extends PaymentSendDocumentState {
  const PaymentSendDocumentEmptyState();
}

class PaymentSendDocumentLoadingState extends PaymentSendDocumentState {
  const PaymentSendDocumentLoadingState();
}

class PaymentSendDocumentFailureState extends PaymentSendDocumentState {
  final Failure error;

  const PaymentSendDocumentFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class PaymentSendDocumentSuccessState extends PaymentSendDocumentState {
  final List<File> files;

  const PaymentSendDocumentSuccessState({required this.files});

  @override
  List<Object?> get props => [files];
}

class PaymentRegistrationEmptyState extends PaymentSendDocumentState {
  const PaymentRegistrationEmptyState();
}

class PaymentRegistrationLoadingState extends PaymentSendDocumentState {
  const PaymentRegistrationLoadingState();
}

class PaymentRegistrationFailureState extends PaymentSendDocumentState {
  final Failure error;

  const PaymentRegistrationFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class PaymentRegistrationSuccessState extends PaymentSendDocumentState {
  const PaymentRegistrationSuccessState();
}

class PaymentRegistrationDocumentSuccessState extends PaymentSendDocumentState {
  const PaymentRegistrationDocumentSuccessState();
}

class PaymentRegistrationDocumentFailureState extends PaymentSendDocumentState {
  final Failure error;

  const PaymentRegistrationDocumentFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class PaymentRegistrationDocumentUnknownProviderFailureState
    extends PaymentSendDocumentState {
  const PaymentRegistrationDocumentUnknownProviderFailureState();
}

class PaymentRegistrationDocumentEmptyState extends PaymentSendDocumentState {
  const PaymentRegistrationDocumentEmptyState();
}

class PaymentRegistrationDocumentLoadingState extends PaymentSendDocumentState {
  const PaymentRegistrationDocumentLoadingState();
}

class PaymentRegistrationFinanceSuccessState extends PaymentSendDocumentState {
  const PaymentRegistrationFinanceSuccessState();
}

class PaymentRegistrationFinanceFailureState extends PaymentSendDocumentState {
  final Failure error;

  const PaymentRegistrationFinanceFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class PaymentRegistrationFinanceEmptyState extends PaymentSendDocumentState {
  const PaymentRegistrationFinanceEmptyState();
}

class PaymentRegistrationFinanceLoadingState extends PaymentSendDocumentState {
  const PaymentRegistrationFinanceLoadingState();
}

class PaymentRegistrationFileSuccessState extends PaymentSendDocumentState {
  const PaymentRegistrationFileSuccessState();
}

class PaymentRegistrationFileFailureState extends PaymentSendDocumentState {
  final Failure error;

  const PaymentRegistrationFileFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class PaymentRegistrationFileEmptyState extends PaymentSendDocumentState {
  const PaymentRegistrationFileEmptyState();
}

class PaymentRegistrationFileLoadingState extends PaymentSendDocumentState {
  const PaymentRegistrationFileLoadingState();
}
