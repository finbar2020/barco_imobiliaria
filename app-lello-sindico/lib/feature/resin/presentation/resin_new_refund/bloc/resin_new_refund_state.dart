import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';
import 'package:lello/feature/resin/domain/entity/resin_check_max_value_param.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';

abstract class ResinNewRefundState {
  String? flushbarMessageKey;
  ResinNewRefundState({this.flushbarMessageKey});
}

class ResinNewRefundLoadingState extends ResinNewRefundState {}

class ResinNewRefundLoadedState extends ResinNewRefundState {
  List<ResinBankAccount> bankAccounts;
  bool loadingRemote;
  ResinNewRefundLoadedState({
    required this.bankAccounts,
    this.loadingRemote = false,
    String? flushbarMessageKey,
  }) : super(flushbarMessageKey: flushbarMessageKey);
}

class ResinNewRefundErrorState extends ResinNewRefundState {
  String errorMessageKey;
  ResinNewRefundErrorState({required this.errorMessageKey});
}

class ResinNewRefundSuccessState extends ResinNewRefundState {
  ResinRefund refund;
  ResinCheckMaxValueParam? checkMaxValueParam;
  ResinNewRefundSuccessState(this.refund, {this.checkMaxValueParam});
}

class ResinCheckValuesSuccessState extends ResinNewRefundState {
  ResinCheckMaxValueParam checkMaxValueParam;
  ResinCheckValuesSuccessState({required this.checkMaxValueParam});
}
