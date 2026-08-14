import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';
import 'package:lello/feature/resin/domain/entity/resin_check_max_value_param.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';

abstract class ResinNewAdvanceState extends Equatable {
  final String? flushbarMessageKey;

  const ResinNewAdvanceState({this.flushbarMessageKey});

  @override
  List<Object?> get props => [flushbarMessageKey];
}

class ResinNewAdvanceLoadingState extends ResinNewAdvanceState {
  const ResinNewAdvanceLoadingState();
}

class ResinNewAdvanceErrorState extends ResinNewAdvanceState {
  final String errorMessageKey;

  const ResinNewAdvanceErrorState({required this.errorMessageKey});

  @override
  List<Object?> get props => [errorMessageKey];
}

class ResinNewAdvanceSuccessState extends ResinNewAdvanceState {
  final ResinRefund refund;

  const ResinNewAdvanceSuccessState(this.refund);

  @override
  List<Object?> get props => [refund];
}

class ResinNewAdvanceLoadedState extends ResinNewAdvanceState {
  final List<ResinBankAccount> bankAccounts;
  final bool loadingRemote;

  const ResinNewAdvanceLoadedState({
    required this.bankAccounts,
    this.loadingRemote = false,
    super.flushbarMessageKey,
  });

  @override
  List<Object?> get props => [bankAccounts, loadingRemote, flushbarMessageKey];
}

class ResinCheckValuesAdvanceSuccessState extends ResinNewAdvanceState {
  final ResinCheckMaxValueParam checkMaxValueParam;

  const ResinCheckValuesAdvanceSuccessState({required this.checkMaxValueParam});

  @override
  List<Object?> get props => [checkMaxValueParam];
}
