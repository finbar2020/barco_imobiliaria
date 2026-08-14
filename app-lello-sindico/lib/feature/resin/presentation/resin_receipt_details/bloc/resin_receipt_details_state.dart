import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';

abstract class ResinReceiptDetailsState extends Equatable {
  final String? flushbarMessageKey;

  const ResinReceiptDetailsState({this.flushbarMessageKey});

  @override
  List<Object?> get props => [flushbarMessageKey];
}

class ResinReceiptDetailsLoadingState extends ResinReceiptDetailsState {
  const ResinReceiptDetailsLoadingState();
}

class ResinReceiptDetailsErrorState extends ResinReceiptDetailsState {
  final String errorMessageKey;

  const ResinReceiptDetailsErrorState({required this.errorMessageKey});

  @override
  List<Object?> get props => [errorMessageKey];
}

class ResinReceiptDetailsLoadedState extends ResinReceiptDetailsState {
  final ResinRefund refund;

  const ResinReceiptDetailsLoadedState({
    super.flushbarMessageKey,
    required this.refund,
  });

  @override
  List<Object?> get props => [refund, flushbarMessageKey];
}
