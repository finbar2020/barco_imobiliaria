import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance_detail.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance_detail_filter.dart';

abstract class BalanceDetailState extends Equatable {
  final String? condominiumId;
  final CondominiumBalanceDetailFilter? filter;
  final CondominiumBalanceDetail? data;

  const BalanceDetailState(this.condominiumId, this.filter, this.data);

  @override
  List<Object?> get props => [condominiumId, filter, data];
}

class BalanceDetailSearchingState extends BalanceDetailState {
  const BalanceDetailSearchingState(
    CondominiumBalanceDetail data,
    String condominiumId,
    CondominiumBalanceDetailFilter filter,
  ) : super(condominiumId, filter, data);
}

class BalanceDetailLoadingState extends BalanceDetailState {
  const BalanceDetailLoadingState(
    CondominiumBalanceDetail? data,
    String? condominiumId,
    CondominiumBalanceDetailFilter? filter,
  ) : super(condominiumId, filter, data);
}

class BalanceDetailLoadFailedState extends BalanceDetailState {
  final Failure error;

  const BalanceDetailLoadFailedState(
    CondominiumBalanceDetail? data,
    String condominiumId,
    CondominiumBalanceDetailFilter? filter,
    this.error,
  ) : super(condominiumId, filter, data);

  @override
  List<Object?> get props => [...super.props, error];
}

class BalanceDetailPagingState extends BalanceDetailState {
  const BalanceDetailPagingState(
    CondominiumBalanceDetail data,
    String condominiumId,
    CondominiumBalanceDetailFilter filter,
  ) : super(condominiumId, filter, data);
}

class BalanceDetailPageFailedState extends BalanceDetailState {
  final Failure error;

  const BalanceDetailPageFailedState(
    CondominiumBalanceDetail data,
    String condominiumId,
    CondominiumBalanceDetailFilter filter,
    this.error,
  ) : super(condominiumId, filter, data);

  @override
  List<Object?> get props => [...super.props, error];
}

class BalanceDetailLoadedState extends BalanceDetailState {
  final bool donePaging;
  final bool remoteFail;

  const BalanceDetailLoadedState(
    CondominiumBalanceDetail data,
    String condominiumId,
    CondominiumBalanceDetailFilter? filter,
    this.donePaging, {
    this.remoteFail = false,
  }) : super(condominiumId, filter, data);

  @override
  List<Object?> get props => [...super.props, donePaging, remoteFail];
}
