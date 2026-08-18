import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';
import 'package:lello/feature/resin/domain/entity/resin_check_max_value_param.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';

abstract class ResinNewRefundEvent {
  ResinNewRefundEvent();
}

class ResinNewRefundLoadingEvent extends ResinNewRefundEvent {}

class ResinNewRefundLoadedEvent extends ResinNewRefundEvent {
  List<ResinBankAccount> bankAccounts;
  bool loadingRemote;
  String? flushbarMessageKey;
  ResinNewRefundLoadedEvent({
    required this.bankAccounts,
    this.loadingRemote = false,
    this.flushbarMessageKey,
  });
}

class ResinNewRefundErrorEvent extends ResinNewRefundEvent {
  String errorMessageKey;
  ResinNewRefundErrorEvent({required this.errorMessageKey});
}

class ResinNewRefundSuccessEvent extends ResinNewRefundEvent {
  ResinRefund refund;
  ResinCheckMaxValueParam? checkMaxValueParam;
  ResinNewRefundSuccessEvent(this.refund, {this.checkMaxValueParam});
}

class ResinCheckValuesSuccessEvent extends ResinNewRefundEvent {
  ResinCheckMaxValueParam checkMaxValueParam;
  ResinCheckValuesSuccessEvent({required this.checkMaxValueParam});
}
