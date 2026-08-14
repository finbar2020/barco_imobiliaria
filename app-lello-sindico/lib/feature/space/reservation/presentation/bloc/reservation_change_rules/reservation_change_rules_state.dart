import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_change_rules.dart';

abstract class ReservationChangeRulesState extends Equatable {
  const ReservationChangeRulesState();

  @override
  List<Object?> get props => [];
}

class ReservationChangeRulesEmptyState extends ReservationChangeRulesState {
  const ReservationChangeRulesEmptyState();
}

class ReservationChangeRulesLoadingState extends ReservationChangeRulesState {
  const ReservationChangeRulesLoadingState();
}

class ReservationChangeRulesLoadedState extends ReservationChangeRulesState {
  final ReservationChangeRules rules;

  const ReservationChangeRulesLoadedState({
    required this.rules,
  });

  @override
  List<Object?> get props => [rules];
}

class PostSuccessState extends ReservationChangeRulesState {
  const PostSuccessState();
}

class ReservationChangeRulesFailedState extends ReservationChangeRulesState {
  const ReservationChangeRulesFailedState();
}

class ReservationChangeRulesFailedGetState extends ReservationChangeRulesState {
  const ReservationChangeRulesFailedGetState();
}
