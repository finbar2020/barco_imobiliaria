import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';

abstract class ResinSendReceiptState extends Equatable {
  final String? flushbarMessageKey;

  const ResinSendReceiptState({this.flushbarMessageKey});

  @override
  List<Object?> get props => [flushbarMessageKey];
}

class ResinSendReceiptLoadingState extends ResinSendReceiptState {
  const ResinSendReceiptLoadingState();
}

class ResinSendReceiptErrorState extends ResinSendReceiptState {
  final String errorMessageKey;

  const ResinSendReceiptErrorState({required this.errorMessageKey});

  @override
  List<Object?> get props => [errorMessageKey];
}

class ResinSendReceiptLoadedState extends ResinSendReceiptState {
  final List<ResinRefund> refunds;
  final bool loadingRemote;

  const ResinSendReceiptLoadedState({
    required this.refunds,
    this.loadingRemote = false,
    super.flushbarMessageKey,
  });

  @override
  List<Object?> get props => [refunds, loadingRemote, flushbarMessageKey];
}
