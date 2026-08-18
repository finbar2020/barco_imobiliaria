import 'package:lello/feature/resin/domain/entity/resin_refund.dart';

abstract class ResinHistoryAdvanceState {
  String? flushbarMessageKey;
  ResinHistoryAdvanceState({this.flushbarMessageKey});
}

class ResinHistoryAdvanceEmptyState extends ResinHistoryAdvanceState {}

class ResinHistoryAdvanceLoadingState extends ResinHistoryAdvanceState {}

class ResinHistoryAdvanceErrorState extends ResinHistoryAdvanceState {
  String errorMessageKey;
  ResinHistoryAdvanceErrorState({required this.errorMessageKey});
}

class ResinHistoryAdvanceLoadedState extends ResinHistoryAdvanceState {
  List<ResinRefund> refunds;
  bool loadingRemote;
  bool updateRefunds;
  ResinHistoryAdvanceLoadedState({
    required this.refunds,
    this.loadingRemote = false,
    this.updateRefunds = false,
    String? flushbarMessageKey,
  }) : super(flushbarMessageKey: flushbarMessageKey);
}

class ResinDeleteHistoryAdvanceLoadingState extends ResinHistoryAdvanceState {}

class ResinAdvanceDetailsLoadedState extends ResinHistoryAdvanceState {
  ResinRefund refund;
  ResinAdvanceDetailsLoadedState(this.refund);
}
