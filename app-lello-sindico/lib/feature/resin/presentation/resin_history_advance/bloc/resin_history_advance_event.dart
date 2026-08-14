import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';

abstract class ResinHistoryAdvanceEvent extends Equatable {
  const ResinHistoryAdvanceEvent();

  @override
  List<Object?> get props => [];
}

class ResinHistoryAdvanceLoadingEvent extends ResinHistoryAdvanceEvent {
  const ResinHistoryAdvanceLoadingEvent();
}

class ResinHistoryAdvanceLoadedEvent extends ResinHistoryAdvanceEvent {
  final List<ResinRefund> refunds;
  final bool loadingRemote;
  final bool updateRefunds;
  final String? flushbarMessageKey;

  const ResinHistoryAdvanceLoadedEvent({
    required this.refunds,
    this.loadingRemote = false,
    this.updateRefunds = false,
    this.flushbarMessageKey,
  });

  @override
  List<Object?> get props =>
      [refunds, loadingRemote, updateRefunds, flushbarMessageKey];
}

class ResinHistoryAdvanceErrorEvent extends ResinHistoryAdvanceEvent {
  final String errorMessageKey;

  const ResinHistoryAdvanceErrorEvent({required this.errorMessageKey});

  @override
  List<Object?> get props => [errorMessageKey];
}

class ResinHistoryAdvanceDeleteLoadingEvent extends ResinHistoryAdvanceEvent {
  const ResinHistoryAdvanceDeleteLoadingEvent();
}

class ResinAdvanceDetailsLoadedEvent extends ResinHistoryAdvanceEvent {
  final ResinRefund refund;

  const ResinAdvanceDetailsLoadedEvent(this.refund);

  @override
  List<Object?> get props => [refund];
}
