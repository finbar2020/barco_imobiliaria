import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';
import 'package:lello/feature/resin/domain/entity/resin_check_max_value_param.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';

abstract class ResinNewAdvanceState {
  String? flushbarMessageKey;
  ResinNewAdvanceState({this.flushbarMessageKey});
}

class ResinNewAdvanceLoadingState extends ResinNewAdvanceState {}

class ResinNewAdvanceErrorState extends ResinNewAdvanceState {
  String errorMessageKey;
  ResinNewAdvanceErrorState({required this.errorMessageKey});
}

class ResinNewAdvanceSuccessState extends ResinNewAdvanceState {
  ResinRefund refund;
  ResinNewAdvanceSuccessState(this.refund);
}

class ResinNewAdvanceLoadedState extends ResinNewAdvanceState {
  List<ResinBankAccount> bankAccounts;
  bool loadingRemote;
  ResinNewAdvanceLoadedState({
    required this.bankAccounts,
    this.loadingRemote = false,
    String? flushbarMessageKey,
  }) : super(flushbarMessageKey: flushbarMessageKey);
}

class ResinCheckValuesAdvanceSuccessState extends ResinNewAdvanceState {
  ResinCheckMaxValueParam checkMaxValueParam;
  ResinCheckValuesAdvanceSuccessState({required this.checkMaxValueParam});
}
