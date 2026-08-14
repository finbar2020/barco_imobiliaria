import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';

abstract class ResinHistoryRefundEvent extends Equatable {
  const ResinHistoryRefundEvent();

  @override
  List<Object?> get props => [];
}

class ResinHistoryRefundLoadingEvent extends ResinHistoryRefundEvent {
  const ResinHistoryRefundLoadingEvent();
}

class ResinHistoryRefundLoadedEvent extends ResinHistoryRefundEvent {
  final List<ResinRefund> refunds;
  final bool loadingRemote;
  final bool updateRefunds;
  final String? flushbarMessageKey;

  const ResinHistoryRefundLoadedEvent({
    required this.refunds,
    this.loadingRemote = false,
    this.updateRefunds = false,
    this.flushbarMessageKey,
  });

  @override
  List<Object?> get props =>
      [refunds, loadingRemote, updateRefunds, flushbarMessageKey];
}

class ResinHistoryRefundErrorEvent extends ResinHistoryRefundEvent {
  final String errorMessageKey;

  const ResinHistoryRefundErrorEvent({required this.errorMessageKey});

  @override
  List<Object?> get props => [errorMessageKey];
}

class ResinHistoryRefundDeleteLoadingEvent extends ResinHistoryRefundEvent {
  const ResinHistoryRefundDeleteLoadingEvent();
}

class ResinRefundDetailsLoadedEvent extends ResinHistoryRefundEvent {
  final ResinRefund refund;

  const ResinRefundDetailsLoadedEvent(this.refund);

  @override
  List<Object?> get props => [refund];
}
