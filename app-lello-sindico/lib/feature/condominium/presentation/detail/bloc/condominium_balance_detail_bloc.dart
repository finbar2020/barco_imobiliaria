import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance_detail_filter.dart';

import 'condominium_balance_detail_event.dart';
import 'condominium_balance_detail_state.dart';

abstract class BalanceDetailBloc
    extends Bloc<BalanceDetailEvent, BalanceDetailState> {
  BalanceDetailBloc(BalanceDetailState initialState) : super(initialState);

  void beginRefresh(CondominiumBalanceDetailFilter filter);
}
