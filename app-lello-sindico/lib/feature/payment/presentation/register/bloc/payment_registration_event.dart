import 'dart:io';

import 'package:essentials/essentials.dart';

abstract class PaymentSendDocumentEvent {}

// Send documents

class PaymentSendDocumentEmptyEvent extends PaymentSendDocumentEvent {}

class PaymentSendDocumentLoadingEvent extends PaymentSendDocumentEvent {}

class PaymentSendDocumentFailureEvent extends PaymentSendDocumentEvent {
  final Failure error;
  PaymentSendDocumentFailureEvent({required this.error});
}

class PaymentSendDocumentSuccessEvent extends PaymentSendDocumentEvent {
  final List<File> files;
  PaymentSendDocumentSuccessEvent({required this.files});
}
