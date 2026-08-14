import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_change_rules.dart';

abstract class ReservationChangeRulesEvent extends Equatable {
  const ReservationChangeRulesEvent();

  @override
  List<Object?> get props => [];
}

class PostChangeRuleEvent extends ReservationChangeRulesEvent {
  final ReservationChangeRules model;

  const PostChangeRuleEvent({required this.model});

  @override
  List<Object?> get props => [model];
}

class GetChangeRuleEvent extends ReservationChangeRulesEvent {
  const GetChangeRuleEvent();
}
