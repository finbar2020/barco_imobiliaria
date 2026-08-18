import 'package:lello/feature/resin/domain/entity/resin_refund.dart';

abstract class ResinHistoryRefundState {
  String? flushbarMessageKey;
  ResinHistoryRefundState({this.flushbarMessageKey});
}

class ResinHistoryRefundLoadingState extends ResinHistoryRefundState {}

class ResinHistoryRefundLoadedState extends ResinHistoryRefundState {
  List<ResinRefund> refunds;
  bool loadingRemote;
  bool updateRefunds;
  ResinHistoryRefundLoadedState({
    required this.refunds,
    this.loadingRemote = false,
    this.updateRefunds = false,
    String? flushbarMessageKey,
  }) : super(flushbarMessageKey: flushbarMessageKey);
}

class ResinHistoryRefundErrorState extends ResinHistoryRefundState {
  String errorMessageKey;
  ResinHistoryRefundErrorState({required this.errorMessageKey});
}

class ResinDeleteHistoryRefundLoadingState extends ResinHistoryRefundState {}

class ResinRefundDetailsLoadedState extends ResinHistoryRefundState {
  ResinRefund refund;
  ResinRefundDetailsLoadedState(this.refund);
}
