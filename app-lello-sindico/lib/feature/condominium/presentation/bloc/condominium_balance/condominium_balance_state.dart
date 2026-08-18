import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance.dart';

abstract class CondominiumBalanceState {}

class CondominiumBalanceIdleState extends CondominiumBalanceState {}

class CondominiumBalanceLoadingState extends CondominiumBalanceState {}

class CondominiumBalanceLoadedState extends CondominiumBalanceState {
  final CondominiumBalance balance;
  bool isUpdating;
  bool remoteFail;
  CondominiumBalanceLoadedState(
      {required this.balance,
      this.isUpdating = false,
      this.remoteFail = false});
}

class CondominiumBalanceFailedState extends CondominiumBalanceState {
  final Failure? failure;
  CondominiumBalanceFailedState({this.failure});
}
