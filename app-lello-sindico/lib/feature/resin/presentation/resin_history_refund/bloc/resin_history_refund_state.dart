import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';

abstract class ResinHistoryRefundState extends Equatable {
  final String? flushbarMessageKey;

  const ResinHistoryRefundState({this.flushbarMessageKey});

  @override
  List<Object?> get props => [flushbarMessageKey];
}

class ResinHistoryRefundLoadingState extends ResinHistoryRefundState {
  const ResinHistoryRefundLoadingState();
}

class ResinHistoryRefundLoadedState extends ResinHistoryRefundState {
  final List<ResinRefund> refunds;
  final bool loadingRemote;
  final bool updateRefunds;

  const ResinHistoryRefundLoadedState({
    required this.refunds,
    this.loadingRemote = false,
    this.updateRefunds = false,
    super.flushbarMessageKey,
  });

  @override
  List<Object?> get props =>
      [refunds, loadingRemote, updateRefunds, flushbarMessageKey];
}

class ResinHistoryRefundErrorState extends ResinHistoryRefundState {
  final String errorMessageKey;

  const ResinHistoryRefundErrorState({required this.errorMessageKey});

  @override
  List<Object?> get props => [errorMessageKey];
}

class ResinDeleteHistoryRefundLoadingState extends ResinHistoryRefundState {
  const ResinDeleteHistoryRefundLoadingState();
}

class ResinRefundDetailsLoadedState extends ResinHistoryRefundState {
  final ResinRefund refund;

  const ResinRefundDetailsLoadedState(this.refund);

  @override
  List<Object?> get props => [refund];
}
