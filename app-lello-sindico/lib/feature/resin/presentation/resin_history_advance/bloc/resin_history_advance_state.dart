import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';

abstract class ResinHistoryAdvanceState extends Equatable {
  final String? flushbarMessageKey;

  const ResinHistoryAdvanceState({this.flushbarMessageKey});

  @override
  List<Object?> get props => [flushbarMessageKey];
}

class ResinHistoryAdvanceEmptyState extends ResinHistoryAdvanceState {
  const ResinHistoryAdvanceEmptyState();
}

class ResinHistoryAdvanceLoadingState extends ResinHistoryAdvanceState {
  const ResinHistoryAdvanceLoadingState();
}

class ResinHistoryAdvanceErrorState extends ResinHistoryAdvanceState {
  final String errorMessageKey;

  const ResinHistoryAdvanceErrorState({required this.errorMessageKey});

  @override
  List<Object?> get props => [errorMessageKey];
}

class ResinHistoryAdvanceLoadedState extends ResinHistoryAdvanceState {
  final List<ResinRefund> refunds;
  final bool loadingRemote;
  final bool updateRefunds;

  const ResinHistoryAdvanceLoadedState({
    required this.refunds,
    this.loadingRemote = false,
    this.updateRefunds = false,
    super.flushbarMessageKey,
  });

  @override
  List<Object?> get props =>
      [refunds, loadingRemote, updateRefunds, flushbarMessageKey];
}

class ResinDeleteHistoryAdvanceLoadingState extends ResinHistoryAdvanceState {
  const ResinDeleteHistoryAdvanceLoadingState();
}

class ResinAdvanceDetailsLoadedState extends ResinHistoryAdvanceState {
  final ResinRefund refund;

  const ResinAdvanceDetailsLoadedState(this.refund);

  @override
  List<Object?> get props => [refund];
}
