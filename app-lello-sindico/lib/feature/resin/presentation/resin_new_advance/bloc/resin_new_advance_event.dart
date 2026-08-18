import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';
import 'package:lello/feature/resin/domain/entity/resin_check_max_value_param.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';

abstract class ResinNewAdvanceEvent {
  ResinNewAdvanceEvent();
}

class ResinNewAdvanceLoadingEvent extends ResinNewAdvanceEvent {}

class ResinNewAdvanceLoadedEvent extends ResinNewAdvanceEvent {
  List<ResinBankAccount> bankAccounts;
  bool loadingRemote;
  String? flushbarMessageKey;
  ResinNewAdvanceLoadedEvent({
    required this.bankAccounts,
    this.loadingRemote = false,
    this.flushbarMessageKey,
  });
}

class ResinNewAdvanceErrorEvent extends ResinNewAdvanceEvent {
  String errorMessageKey;
  ResinNewAdvanceErrorEvent({required this.errorMessageKey});
}

class ResinNewAdvanceSuccessEvent extends ResinNewAdvanceEvent {
  ResinRefund refund;
  ResinNewAdvanceSuccessEvent(this.refund);
}

class ResinCheckValuesSuccessEvent extends ResinNewAdvanceEvent {
  ResinCheckMaxValueParam checkMaxValueParam;
  ResinCheckValuesSuccessEvent({required this.checkMaxValueParam});
}
