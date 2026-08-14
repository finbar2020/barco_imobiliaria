import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';

abstract class ResinSendReceiptEvent extends Equatable {
  const ResinSendReceiptEvent();

  @override
  List<Object?> get props => [];
}

class ResinSendReceiptLoadingEvent extends ResinSendReceiptEvent {
  const ResinSendReceiptLoadingEvent();
}

class ResinSendReceiptSuccessEvent extends ResinSendReceiptEvent {
  final List<ResinRefund> refunds;
  final bool loadingRemote;
  final String? flushbarMessageKey;

  const ResinSendReceiptSuccessEvent({
    required this.refunds,
    this.loadingRemote = false,
    this.flushbarMessageKey,
  });

  @override
  List<Object?> get props => [refunds, loadingRemote, flushbarMessageKey];
}

class ResinSendReceiptErrorEvent extends ResinSendReceiptEvent {
  final String errorMessageKey;

  const ResinSendReceiptErrorEvent({required this.errorMessageKey});

  @override
  List<Object?> get props => [errorMessageKey];
}
