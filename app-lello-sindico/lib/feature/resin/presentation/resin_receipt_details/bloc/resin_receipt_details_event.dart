import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';

abstract class ResinReceiptDetailsEvent extends Equatable {
  const ResinReceiptDetailsEvent();

  @override
  List<Object?> get props => [];
}

class ResinReceiptDetailsLoadingEvent extends ResinReceiptDetailsEvent {
  const ResinReceiptDetailsLoadingEvent();
}

class ResinReceiptDetailsLoadedEvent extends ResinReceiptDetailsEvent {
  final ResinRefund refund;
  final String? flushbarMessageKey;

  const ResinReceiptDetailsLoadedEvent({
    required this.refund,
    this.flushbarMessageKey,
  });

  @override
  List<Object?> get props => [refund, flushbarMessageKey];
}

class ResinReceiptDetailsErrorEvent extends ResinReceiptDetailsEvent {
  final String errorMessageKey;

  const ResinReceiptDetailsErrorEvent({required this.errorMessageKey});

  @override
  List<Object?> get props => [errorMessageKey];
}
