import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance.dart';

abstract class CondominiumBalanceState extends Equatable {
  const CondominiumBalanceState();

  @override
  List<Object?> get props => [];
}

class CondominiumBalanceInitialState extends CondominiumBalanceState {
  const CondominiumBalanceInitialState();
}

class CondominiumBalanceLoadingState extends CondominiumBalanceState {
  const CondominiumBalanceLoadingState();
}

class CondominiumBalanceLoadedState extends CondominiumBalanceState {
  final CondominiumBalance balance;
  final bool isUpdating;
  final bool remoteFail;

  const CondominiumBalanceLoadedState({
    required this.balance,
    this.isUpdating = false,
    this.remoteFail = false,
  });

  @override
  List<Object?> get props => [balance, isUpdating, remoteFail];
}

class CondominiumBalanceFailedState extends CondominiumBalanceState {
  final Failure? failure;

  const CondominiumBalanceFailedState({this.failure});

  @override
  List<Object?> get props => [failure];
}
