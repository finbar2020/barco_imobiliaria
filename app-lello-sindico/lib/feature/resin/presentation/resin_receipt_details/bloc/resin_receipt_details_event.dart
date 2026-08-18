import 'package:lello/feature/resin/domain/entity/resin_refund.dart';

abstract class ResinReceiptDetailsEvent {
  ResinReceiptDetailsEvent();
}

class ResinReceiptDetailsLoadingEvent extends ResinReceiptDetailsEvent {}

class ResinReceiptDetailsLoadedEvent extends ResinReceiptDetailsEvent {
  final ResinRefund refund;
  final String? flushbarMessageKey;

  ResinReceiptDetailsLoadedEvent(
      {required this.refund, this.flushbarMessageKey});
}

class ResinReceiptDetailsErrorEvent extends ResinReceiptDetailsEvent {
  String errorMessageKey;
  ResinReceiptDetailsErrorEvent({required this.errorMessageKey});
}
