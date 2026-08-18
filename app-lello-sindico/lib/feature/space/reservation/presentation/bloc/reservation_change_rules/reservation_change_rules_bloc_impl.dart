import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_change_rules.dart';
import 'package:lello/feature/space/reservation/domain/use_case/get_reservation_change_rules/get_reservation_change_rules.dart';
import 'package:lello/feature/space/reservation/domain/use_case/post_reservation_change_rules/post_reservation_change_rules.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_change_rules/reservation_change_rules_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_change_rules/reservation_change_rules_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_change_rules/reservation_change_rules_state.dart';

class ReservationChangesRulesBlocImpl extends ReservationChangeRulesBloc {
  final PostReservationChangeRules post;
  final GetReservationChangeRules getChangeRules;
  final SessionBloc sessionBloc;

  ReservationChangesRulesBlocImpl({
    required this.post,
    required this.getChangeRules,
    required this.sessionBloc,
  }) : super(ReservationChangeRulesEmptyState());

  @override
  Stream<ReservationChangeRulesState> mapEventToState(
      ReservationChangeRulesEvent event) async* {
    if (event is GetChangeRuleEvent) yield* _mapGet(event);
    if (event is PostChangeRuleEvent) yield* _mapPost(event);
  }

  Stream<ReservationChangeRulesState> _mapGet(GetChangeRuleEvent event) async* {
    yield ReservationChangeRulesLoadingState();

    final response = await getChangeRules.call(GetReservationChangeRulesParam(
        condominiumId: sessionBloc.state.session!.selectedCondominium!.id));

    final result =
        response.fold((error) => ReservationChangeRulesFailedGetState(), (res) {
      String reference = sessionBloc
              .state.session!.selectedCondominium?.reference
              .toString() ??
          "";
      ManagerAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsManager.condAreasRegrasAcessar(),
          referenceValue: reference);
      return ReservationChangeRulesLoadedState(
        rules: res,
      );
    });
    yield result;
  }

  Stream<ReservationChangeRulesState> _mapPost(
      PostChangeRuleEvent event) async* {
    yield ReservationChangeRulesLoadingState();
    if (!event.model.allowedDaysList!.contains(0) &&
        !event.model.allowedDaysList!.contains(6)) {
      event.model.weekendHourStart = null;
      event.model.weekendHourEnd = null;
    }
    if (!event.model.allowedDaysList!.contains(1) &&
        !event.model.allowedDaysList!.contains(2) &&
        !event.model.allowedDaysList!.contains(3) &&
        !event.model.allowedDaysList!.contains(4) &&
        !event.model.allowedDaysList!.contains(5)) {
      event.model.weekHourStart = null;
      event.model.weekHourEnd = null;
    }
    event.model.allowedDaysList!.sort((a, b) => a.compareTo(b));
    Map<String, dynamic> body = {
      "reference": sessionBloc.state.session!.selectedCondominium!.reference,
      "week_hour_start": event.model.weekHourStart ?? "",
      "week_hour_end": event.model.weekHourEnd ?? "",
      "weekend_hour_start": event.model.weekendHourStart ?? "",
      "weekend_hour_end": event.model.weekendHourEnd ?? "",
      "allow_holiday": false,
      "days_in_advance": event.model.setDiasAntecedencia(event.model.setDays),
      "max_per_day": event.model.maxPerDay,
      "allowed_days_list": event.model.allowedDaysList
    };

    final response = await post.call(PostReservationChangeRulesParam(
        body: body,
        condominiumId:
            sessionBloc.state.session!.selectedCondominium!.reference));

    final result =
        response.fold((error) => ReservationChangeRulesFailedState(), (res) {
      String reference = sessionBloc
              .state.session!.selectedCondominium?.reference
              .toString() ??
          "";
      ManagerAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsManager.condAreasRegrasFinalizado(),
          referenceValue: reference);
      return PostSuccessState();
    });
    yield result;
  }

  @override
  void postRules({required ReservationChangeRules body}) {
    add(PostChangeRuleEvent(model: body));
  }

  @override
  void getRules() {
    add(GetChangeRuleEvent());
  }
}
