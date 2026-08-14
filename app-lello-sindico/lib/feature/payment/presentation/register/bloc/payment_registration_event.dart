import 'dart:io';

import 'package:essentials/essentials.dart';

abstract class PaymentSendDocumentEvent extends Equatable {
  const PaymentSendDocumentEvent();

  @override
  List<Object?> get props => [];
}

class PaymentSendDocumentEmptyEvent extends PaymentSendDocumentEvent {
  const PaymentSendDocumentEmptyEvent();
}

class PaymentSendDocumentLoadingEvent extends PaymentSendDocumentEvent {
  const PaymentSendDocumentLoadingEvent();
}

class PaymentSendDocumentFailureEvent extends PaymentSendDocumentEvent {
  final Failure error;

  const PaymentSendDocumentFailureEvent({required this.error});

  @override
  List<Object?> get props => [error];
}

class PaymentSendDocumentSuccessEvent extends PaymentSendDocumentEvent {
  final List<File> files;

  const PaymentSendDocumentSuccessEvent({required this.files});

  @override
  List<Object?> get props => [files];
}
