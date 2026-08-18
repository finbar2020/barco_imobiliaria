import 'package:lello/feature/condominium/domain/entity/condominium_balance_detail_filter.dart';

abstract class BalanceDetailEvent {}

class BalanceDetailLoadEvent extends BalanceDetailEvent {
  final String condominiumId;
  final CondominiumBalanceDetailFilter? filter;
  final String? reference;

  BalanceDetailLoadEvent(
      {required this.condominiumId, this.filter, this.reference});
}

class BalanceDetailNextPageEvent extends BalanceDetailEvent {}

class BalanceDetailSearchEvent extends BalanceDetailEvent {
  final String query;
  BalanceDetailSearchEvent({required this.query});
}
