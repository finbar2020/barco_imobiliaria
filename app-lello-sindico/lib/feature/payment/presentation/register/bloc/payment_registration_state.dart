import 'dart:io';

import 'package:essentials/essentials.dart';

abstract class PaymentSendDocumentState {}

// Send documents

class PaymentSendDocumentEmptyState extends PaymentSendDocumentState {}

class PaymentSendDocumentLoadingState extends PaymentSendDocumentState {}

class PaymentSendDocumentFailureState extends PaymentSendDocumentState {
  final Failure error;
  PaymentSendDocumentFailureState({required this.error});
}

class PaymentSendDocumentSuccessState extends PaymentSendDocumentState {
  final List<File> files;
  PaymentSendDocumentSuccessState({required this.files});
}

// Registration (old)

class PaymentRegistrationEmptyState extends PaymentSendDocumentState {}

class PaymentRegistrationLoadingState extends PaymentSendDocumentState {}

class PaymentRegistrationFailureState extends PaymentSendDocumentState {
  final Failure error;
  PaymentRegistrationFailureState({required this.error});
}

class PaymentRegistrationSuccessState extends PaymentSendDocumentState {}

// Step 1 [Document]
class PaymentRegistrationDocumentSuccessState
    extends PaymentSendDocumentState {}

class PaymentRegistrationDocumentFailureState extends PaymentSendDocumentState {
  final Failure error;
  PaymentRegistrationDocumentFailureState({required this.error});
}

class PaymentRegistrationDocumentUnknownProviderFailureState
    extends PaymentSendDocumentState {}

class PaymentRegistrationDocumentEmptyState extends PaymentSendDocumentState {}

class PaymentRegistrationDocumentLoadingState
    extends PaymentSendDocumentState {}

// Step 2 [Finance]
class PaymentRegistrationFinanceSuccessState extends PaymentSendDocumentState {}

class PaymentRegistrationFinanceFailureState extends PaymentSendDocumentState {
  final Failure error;
  PaymentRegistrationFinanceFailureState({required this.error});
}

class PaymentRegistrationFinanceEmptyState extends PaymentSendDocumentState {}

class PaymentRegistrationFinanceLoadingState extends PaymentSendDocumentState {}

// Step 3 [File]
class PaymentRegistrationFileSuccessState extends PaymentSendDocumentState {}

class PaymentRegistrationFileFailureState extends PaymentSendDocumentState {
  final Failure error;
  PaymentRegistrationFileFailureState({required this.error});
}

class PaymentRegistrationFileEmptyState extends PaymentSendDocumentState {}

class PaymentRegistrationFileLoadingState extends PaymentSendDocumentState {}
