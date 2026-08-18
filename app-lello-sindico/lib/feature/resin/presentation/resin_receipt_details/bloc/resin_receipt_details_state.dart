import 'package:lello/feature/resin/domain/entity/resin_refund.dart';

abstract class ResinReceiptDetailsState {
  String? flushbarMessageKey;
  ResinReceiptDetailsState({this.flushbarMessageKey});
}

class ResinReceiptDetailsLoadingState extends ResinReceiptDetailsState {}

class ResinReceiptDetailsErrorState extends ResinReceiptDetailsState {
  String errorMessageKey;
  ResinReceiptDetailsErrorState({required this.errorMessageKey});
}

class ResinReceiptDetailsLoadedState extends ResinReceiptDetailsState {
  ResinRefund refund;
  ResinReceiptDetailsLoadedState({
    String? flushbarMessageKey,
    required this.refund,
  }) : super(flushbarMessageKey: flushbarMessageKey);
}
