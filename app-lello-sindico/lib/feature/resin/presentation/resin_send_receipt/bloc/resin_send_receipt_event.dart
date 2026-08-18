import 'package:lello/feature/resin/domain/entity/resin_refund.dart';

abstract class ResinSendReceiptEvent {
  ResinSendReceiptEvent();
}

class ResinSendReceiptLoadingEvent extends ResinSendReceiptEvent {}

class ResinSendReceiptSuccessEvent extends ResinSendReceiptEvent {
  List<ResinRefund> refunds;
  bool loadingRemote;

  ResinSendReceiptSuccessEvent({
    required this.refunds,
    this.loadingRemote = false,
    String? flushbarMessageKey,
  });
}

class ResinSendReceiptErrorEvent extends ResinSendReceiptEvent {
  String errorMessageKey;
  ResinSendReceiptErrorEvent({required this.errorMessageKey});
}
