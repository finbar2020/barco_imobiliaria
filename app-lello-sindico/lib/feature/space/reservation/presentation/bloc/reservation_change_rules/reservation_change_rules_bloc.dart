import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_change_rules.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_change_rules/reservation_change_rules_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_change_rules/reservation_change_rules_state.dart';

abstract class ReservationChangeRulesBloc
    extends Bloc<ReservationChangeRulesEvent, ReservationChangeRulesState> {
  ReservationChangeRulesBloc(ReservationChangeRulesState initialState)
      : super(initialState);

  void getRules();
  void postRules({required ReservationChangeRules body});
}
