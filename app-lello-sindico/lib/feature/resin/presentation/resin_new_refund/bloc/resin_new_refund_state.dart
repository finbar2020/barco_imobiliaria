import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';
import 'package:lello/feature/resin/domain/entity/resin_check_max_value_param.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';

abstract class ResinNewRefundState extends Equatable {
  final String? flushbarMessageKey;

  const ResinNewRefundState({this.flushbarMessageKey});

  @override
  List<Object?> get props => [flushbarMessageKey];
}

class ResinNewRefundLoadingState extends ResinNewRefundState {
  const ResinNewRefundLoadingState();
}

class ResinNewRefundLoadedState extends ResinNewRefundState {
  final List<ResinBankAccount> bankAccounts;
  final bool loadingRemote;

  const ResinNewRefundLoadedState({
    required this.bankAccounts,
    this.loadingRemote = false,
    super.flushbarMessageKey,
  });

  @override
  List<Object?> get props => [bankAccounts, loadingRemote, flushbarMessageKey];
}

class ResinNewRefundErrorState extends ResinNewRefundState {
  final String errorMessageKey;

  const ResinNewRefundErrorState({required this.errorMessageKey});

  @override
  List<Object?> get props => [errorMessageKey];
}

class ResinNewRefundSuccessState extends ResinNewRefundState {
  final ResinRefund refund;
  final ResinCheckMaxValueParam? checkMaxValueParam;

  const ResinNewRefundSuccessState(this.refund, {this.checkMaxValueParam});

  @override
  List<Object?> get props => [refund, checkMaxValueParam];
}

class ResinCheckValuesSuccessState extends ResinNewRefundState {
  final ResinCheckMaxValueParam checkMaxValueParam;

  const ResinCheckValuesSuccessState({required this.checkMaxValueParam});

  @override
  List<Object?> get props => [checkMaxValueParam];
}
