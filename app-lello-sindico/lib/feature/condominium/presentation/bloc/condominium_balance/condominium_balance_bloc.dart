import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/condominium/presentation/bloc/condominium_balance/condominium_balance_event.dart';
import 'package:lello/feature/condominium/presentation/bloc/condominium_balance/condominium_balance_state.dart';

abstract class CondominiumBalanceBloc
    extends Bloc<CondominiumBalanceEvent, CondominiumBalanceState> {
  CondominiumBalanceBloc(super.initialState);
}
