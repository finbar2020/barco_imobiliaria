import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance_detail_filter.dart';

abstract class BalanceDetailEvent extends Equatable {
  const BalanceDetailEvent();

  @override
  List<Object?> get props => [];
}

class BalanceDetailLoadEvent extends BalanceDetailEvent {
  final String condominiumId;
  final CondominiumBalanceDetailFilter? filter;
  final String? reference;

  const BalanceDetailLoadEvent({
    required this.condominiumId,
    this.filter,
    this.reference,
  });

  @override
  List<Object?> get props => [condominiumId, filter, reference];
}

class BalanceDetailNextPageEvent extends BalanceDetailEvent {
  const BalanceDetailNextPageEvent();
}

class BalanceDetailSearchEvent extends BalanceDetailEvent {
  final String query;

  const BalanceDetailSearchEvent({required this.query});

  @override
  List<Object?> get props => [query];
}
