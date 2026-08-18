import 'package:lello/feature/resin/domain/entity/resin_refund.dart';

abstract class ResinHistoryAdvanceEvent {
  ResinHistoryAdvanceEvent();
}

class ResinHistoryAdvanceLoadingEvent extends ResinHistoryAdvanceEvent {}

class ResinHistoryAdvanceLoadedEvent extends ResinHistoryAdvanceEvent {
  List<ResinRefund> refunds;
  bool loadingRemote;
  bool updateRefunds;
  String? flushbarMessageKey;
  ResinHistoryAdvanceLoadedEvent({
    required this.refunds,
    this.loadingRemote = false,
    this.updateRefunds = false,
    this.flushbarMessageKey,
  });
}

class ResinHistoryAdvanceErrorEvent extends ResinHistoryAdvanceEvent {
  String errorMessageKey;
  ResinHistoryAdvanceErrorEvent({required this.errorMessageKey});
}

class ResinHistoryAdvanceDeleteLoadingEvent extends ResinHistoryAdvanceEvent {}

class ResinAdvanceDetailsLoadedEvent extends ResinHistoryAdvanceEvent {
  ResinRefund refund;
  ResinAdvanceDetailsLoadedEvent(this.refund);
}
