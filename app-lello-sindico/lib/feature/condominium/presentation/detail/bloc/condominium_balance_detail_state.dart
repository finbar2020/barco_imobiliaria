import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance_detail.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance_detail_filter.dart';

abstract class BalanceDetailState {
  final String? condominiumId;
  final CondominiumBalanceDetailFilter? filter;
  final CondominiumBalanceDetail? data;

  BalanceDetailState(this.condominiumId, this.filter, this.data);
}

class BalanceDetailSearchingState extends BalanceDetailState {
  BalanceDetailSearchingState(CondominiumBalanceDetail data,
      String condominiumId, CondominiumBalanceDetailFilter filter)
      : super(condominiumId, filter, data);
}

class BalanceDetailLoadingState extends BalanceDetailState {
  BalanceDetailLoadingState(CondominiumBalanceDetail? data,
      String? condominiumId, CondominiumBalanceDetailFilter? filter)
      : super(condominiumId, filter, data);
}

class BalanceDetailLoadFailedState extends BalanceDetailState {
  final Failure error;
  BalanceDetailLoadFailedState(CondominiumBalanceDetail? data,
      String condominiumId, CondominiumBalanceDetailFilter? filter, this.error)
      : super(condominiumId, filter, data);
}

class BalanceDetailPagingState extends BalanceDetailState {
  BalanceDetailPagingState(CondominiumBalanceDetail data, String condominiumId,
      CondominiumBalanceDetailFilter filter)
      : super(condominiumId, filter, data);
}

class BalanceDetailPageFailedState extends BalanceDetailState {
  final Failure error;
  BalanceDetailPageFailedState(CondominiumBalanceDetail data,
      String condominiumId, CondominiumBalanceDetailFilter filter, this.error)
      : super(condominiumId, filter, data);
}

class BalanceDetailLoadedState extends BalanceDetailState {
  final bool donePaging;
  final bool remoteFail;
  BalanceDetailLoadedState(CondominiumBalanceDetail data, String condominiumId,
      CondominiumBalanceDetailFilter? filter, this.donePaging,
      {this.remoteFail = false})
      : super(condominiumId, filter, data);
}
