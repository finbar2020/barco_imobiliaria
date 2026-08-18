import 'package:lello/feature/resin/domain/entity/resin_refund.dart';

abstract class ResinHistoryRefundEvent {
  ResinHistoryRefundEvent();
}

class ResinHistoryRefundLoadingEvent extends ResinHistoryRefundEvent {}

class ResinHistoryRefundLoadedEvent extends ResinHistoryRefundEvent {
  List<ResinRefund> refunds;
  bool loadingRemote;
  bool updateRefunds;
  String? flushbarMessageKey;
  ResinHistoryRefundLoadedEvent({
    required this.refunds,
    this.loadingRemote = false,
    this.updateRefunds = false,
    this.flushbarMessageKey,
  });
}

class ResinHistoryRefundErrorEvent extends ResinHistoryRefundEvent {
  String errorMessageKey;
  ResinHistoryRefundErrorEvent({required this.errorMessageKey});
}

class ResinHistoryRefundDeleteLoadingEvent extends ResinHistoryRefundEvent {}

class ResinRefundDetailsLoadedEvent extends ResinHistoryRefundEvent {
  ResinRefund refund;
  ResinRefundDetailsLoadedEvent(this.refund);
}
