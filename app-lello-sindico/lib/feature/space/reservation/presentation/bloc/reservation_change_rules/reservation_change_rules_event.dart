import 'package:lello/feature/space/reservation/domain/entity/reservation_change_rules.dart';

abstract class ReservationChangeRulesEvent {}

class PostChangeRuleEvent extends ReservationChangeRulesEvent {
  final ReservationChangeRules model;

  PostChangeRuleEvent({required this.model});
}

class GetChangeRuleEvent extends ReservationChangeRulesEvent {}
