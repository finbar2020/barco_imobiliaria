import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';
import 'package:lello/feature/resin/domain/entity/resin_check_max_value_param.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';

abstract class ResinNewAdvanceEvent extends Equatable {
  const ResinNewAdvanceEvent();

  @override
  List<Object?> get props => [];
}

class ResinNewAdvanceLoadingEvent extends ResinNewAdvanceEvent {
  const ResinNewAdvanceLoadingEvent();
}

class ResinNewAdvanceLoadedEvent extends ResinNewAdvanceEvent {
  final List<ResinBankAccount> bankAccounts;
  final bool loadingRemote;
  final String? flushbarMessageKey;

  const ResinNewAdvanceLoadedEvent({
    required this.bankAccounts,
    this.loadingRemote = false,
    this.flushbarMessageKey,
  });

  @override
  List<Object?> get props => [bankAccounts, loadingRemote, flushbarMessageKey];
}

class ResinNewAdvanceErrorEvent extends ResinNewAdvanceEvent {
  final String errorMessageKey;

  const ResinNewAdvanceErrorEvent({required this.errorMessageKey});

  @override
  List<Object?> get props => [errorMessageKey];
}

class ResinNewAdvanceSuccessEvent extends ResinNewAdvanceEvent {
  final ResinRefund refund;

  const ResinNewAdvanceSuccessEvent(this.refund);

  @override
  List<Object?> get props => [refund];
}

class ResinCheckValuesSuccessEvent extends ResinNewAdvanceEvent {
  final ResinCheckMaxValueParam checkMaxValueParam;

  const ResinCheckValuesSuccessEvent({required this.checkMaxValueParam});

  @override
  List<Object?> get props => [checkMaxValueParam];
}
