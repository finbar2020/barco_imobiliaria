import 'package:lello/feature/resin/domain/entity/resin_refund.dart';

abstract class ResinSendReceiptState {
  String? flushbarMessageKey;
  ResinSendReceiptState({this.flushbarMessageKey});
}

class ResinSendReceiptLoadingState extends ResinSendReceiptState {}

class ResinSendReceiptErrorState extends ResinSendReceiptState {
  String errorMessageKey;
  ResinSendReceiptErrorState({required this.errorMessageKey});
}

class ResinSendReceiptLoadedState extends ResinSendReceiptState {
  List<ResinRefund> refunds;
  bool loadingRemote;
  ResinSendReceiptLoadedState({
    required this.refunds,
    this.loadingRemote = false,
    String? flushbarMessageKey,
  }) : super(flushbarMessageKey: flushbarMessageKey);
}
