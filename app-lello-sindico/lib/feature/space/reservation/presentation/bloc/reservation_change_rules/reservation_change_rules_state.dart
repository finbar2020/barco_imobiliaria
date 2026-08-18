import 'package:lello/feature/space/reservation/domain/entity/reservation_change_rules.dart';

abstract class ReservationChangeRulesState {}

class ReservationChangeRulesEmptyState extends ReservationChangeRulesState {}

class ReservationChangeRulesLoadingState extends ReservationChangeRulesState {}

class ReservationChangeRulesLoadedState extends ReservationChangeRulesState {
  ReservationChangeRules rules;
  ReservationChangeRulesLoadedState({
    required this.rules,
  });
}

class PostSuccessState extends ReservationChangeRulesState {}

class ReservationChangeRulesFailedState extends ReservationChangeRulesState {}

class ReservationChangeRulesFailedGetState extends ReservationChangeRulesState {
}
