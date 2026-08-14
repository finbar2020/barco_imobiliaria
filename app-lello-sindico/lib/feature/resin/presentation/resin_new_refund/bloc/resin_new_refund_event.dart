import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';
import 'package:lello/feature/resin/domain/entity/resin_check_max_value_param.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';

abstract class ResinNewRefundEvent extends Equatable {
  const ResinNewRefundEvent();

  @override
  List<Object?> get props => [];
}

class ResinNewRefundLoadingEvent extends ResinNewRefundEvent {
  const ResinNewRefundLoadingEvent();
}

class ResinNewRefundLoadedEvent extends ResinNewRefundEvent {
  final List<ResinBankAccount> bankAccounts;
  final bool loadingRemote;
  final String? flushbarMessageKey;

  const ResinNewRefundLoadedEvent({
    required this.bankAccounts,
    this.loadingRemote = false,
    this.flushbarMessageKey,
  });

  @override
  List<Object?> get props => [bankAccounts, loadingRemote, flushbarMessageKey];
}

class ResinNewRefundErrorEvent extends ResinNewRefundEvent {
  final String errorMessageKey;

  const ResinNewRefundErrorEvent({required this.errorMessageKey});

  @override
  List<Object?> get props => [errorMessageKey];
}

class ResinNewRefundSuccessEvent extends ResinNewRefundEvent {
  final ResinRefund refund;
  final ResinCheckMaxValueParam? checkMaxValueParam;

  const ResinNewRefundSuccessEvent(this.refund, {this.checkMaxValueParam});

  @override
  List<Object?> get props => [refund, checkMaxValueParam];
}

class ResinCheckValuesSuccessEvent extends ResinNewRefundEvent {
  final ResinCheckMaxValueParam checkMaxValueParam;

  const ResinCheckValuesSuccessEvent({required this.checkMaxValueParam});

  @override
  List<Object?> get props => [checkMaxValueParam];
}
