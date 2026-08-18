import 'dart:async';

import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/domain/entity/space_calendar_response.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/domain/entity/space_available_hours.dart';
import 'package:lello/feature/space/reservation/domain/use_case/delete_reservation/delete_reservation.dart';
import 'package:lello/feature/space/reservation/domain/use_case/list_all_reservations/list_all_reservation.dart';
import 'package:lello/feature/space/reservation/domain/use_case/list_reservation/list_reservation.dart';
import 'package:lello/feature/space/reservation/domain/use_case/list_reservation/list_reservation_failure.dart';
import 'package:lello/feature/space/reservation/domain/use_case/list_reservation_summary/list_reservation_summary.dart';
import 'package:lello/feature/space/reservation/domain/use_case/register_reservation/register_reservation.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_calendar/reservation_calendar_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_calendar/reservation_calendar_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_calendar/reservation_calendar_state.dart';

class ReservationCalendarBlocImpl extends ReservationCalendarBloc {
  final SessionBloc sessionBloc;
  final ListReservationSummary listReservationSummary;
  final ListReservation listReservation;
  final ListAllReservation listAllReservation;
  final RegisterReservation registerReservation;
  final DeleteReservation delete;

  StreamSubscription? _subscription;

  ReservationCalendarBlocImpl({
    required this.sessionBloc,
    required this.listReservationSummary,
    required this.listAllReservation,
    required this.registerReservation,
    required this.listReservation,
    required this.delete,
  }) : super(ReservationCalendarLoadState(
          SpaceCalendarResponse(),
          [],
          null,
          null,
          null,
          null,
          null,
        )) {
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
  }

  @override
  Stream<ReservationCalendarState> mapEventToState(
      ReservationCalendarEvent event) async* {
    if (event is ReservationCalendarLoadEvent) yield* _mapLoad(event);
    if (event is ReservationCalendarLoadHoursEvent) yield* _mapLoadHours(event);
    if (event is CreateReservationEvent) yield* _mapSendRegistration(event);
    if (event is ReservationCalendarHistoryEvent) yield* _mapLoadHistory(event);
    if (event is DeleteEvent) yield* _mapDelete(event);
  }

  Stream<ReservationCalendarState> _mapSendRegistration(
      CreateReservationEvent event) async* {
    final condominiumId = event.condominiumId;

    yield ReservationCalendarLoadingState(
        state.data,
        state.availableHours,
        state.periodStart,
        state.periodEnd,
        state.selectedDay,
        state.selectedHours,
        condominiumId);

    var data = state.data;
    final registration = ReservationRegistration(
        flagUtilityTerm: true,
        idStatus: 83,
        space: event.space,
        reservationEndDate: event.reservationEndDate,
        reservationStartDate: event.reservationStartDate,
        reservationType: "R",
        spaceId: event.spaceId,
        unitId: event.unitId);

    final response = await registerReservation.call(RegisterReservationParam(
        condominiumId: condominiumId!, registration: registration));

    var resultYield = response.fold(
        (err) => ReservationCalendarLoadFailedState(
            data,
            [],
            state.periodStart,
            state.periodEnd,
            null,
            SpaceAvailableHours(),
            condominiumId,
            err), (data) {
      String reference = sessionBloc
              .state.session!.selectedCondominium?.reference
              .toString() ??
          "";
      ManagerAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsManager.condAreasReservarFinalizado(),
          referenceValue: reference);
      return ReservationCalendarSuccefullCreatedState(
          state.data,
          state.availableHours,
          state.periodStart,
          state.periodEnd,
          null,
          SpaceAvailableHours(),
          condominiumId);
    });

    yield resultYield;
  }

  Stream<ReservationCalendarState> _mapLoadHistory(
      ReservationCalendarHistoryEvent event) async* {
    final condominiumId = event.condominiumId;
    final periodStart = event.periodStart;
    final periodEnd = event.periodEnd;

    yield ReservationCalendarLoadingState(state.data!, [], periodStart!,
        periodEnd!, null, SpaceAvailableHours(), condominiumId!);

    final result = await listAllReservation.call(ListAllReservationParam(
        condominiumId: condominiumId,
        startDate: periodStart,
        endDate: periodEnd));

    print(result);

    yield result.fold(
        (err) => ReservationCalendarLoadFailedState(
            state.data!,
            [],
            periodStart,
            periodEnd,
            null,
            SpaceAvailableHours(),
            condominiumId,
            err), (res) {
      "";
      String reference = sessionBloc
              .state.session!.selectedCondominium?.reference
              .toString() ??
          "";
      ManagerAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsManager.condAreasAgendaAcessar(),
          referenceValue: reference);
      return ReservationCalendarHistoryLoadedState(state.data!, [], periodStart,
          periodEnd, null, SpaceAvailableHours(), condominiumId, res);
    });
  }

  Stream<ReservationCalendarState> _mapLoad(
      ReservationCalendarLoadEvent event) async* {
    final condominiumId = event.condominiumId;
    final periodStart = event.periodStart;
    final periodEnd = event.periodEnd;

    var data = state.data!;

    yield ReservationCalendarLoadingState(data, [], periodStart!, periodEnd!,
        null, SpaceAvailableHours(), condominiumId!);

    final result = await listReservationSummary.call(
        ListReservationSummaryParam(
            spaceId: event.spaceId!,
            condominiumId: condominiumId,
            periodStart: periodStart,
            periodEnd: periodEnd,
            origin: DataOrigin.remote));
    yield result.fold(
        (err) => ReservationCalendarLoadFailedState(data, [], periodStart,
            periodEnd, null, SpaceAvailableHours(), condominiumId, err),
        (data) => ReservationCalendarLoadedState(data, [], periodStart,
            periodEnd, null, SpaceAvailableHours(), condominiumId));
  }

  Stream<ReservationCalendarState> _mapLoadHours(
      ReservationCalendarLoadHoursEvent event) async* {
    final condominiumId = event.condominiumId;
    final date = event.date;

    var data = state.data;
    yield ReservationCalendarHoursLoadingState(
      data,
      [],
      state.periodStart,
      state.periodEnd,
      state.selectedDay,
      state.selectedHours,
      condominiumId!,
    );

    final result = await listReservation.call(ListReservationParam(
        condominiumId: condominiumId,
        unitId: event.unitId!,
        spaceId: event.spaceId!,
        date: date!));

    yield result.fold((err) {
      if (err is UnitExceededReservationLimit) {
        return ReservationUnitExceededFailedState(
            data!,
            [],
            state.periodStart,
            state.periodEnd,
            state.selectedDay,
            state.selectedHours,
            condominiumId,
            err);
      }
      return ReservationCalendarLoadFailedState(
          data!,
          [],
          state.periodStart!,
          state.periodEnd!,
          state.selectedDay,
          state.selectedHours!,
          condominiumId,
          err);
    },
        (res) => ReservationCalendarLoadedState(
            data,
            res,
            state.periodStart,
            state.periodEnd,
            state.selectedDay,
            state.selectedHours,
            condominiumId));
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState) {
      beginLoadCalendarHistory();
    }
  }

  @override
  void beginLoad(String spaceId) {
    if (state is ReservationCalendarLoadingState) return;

    DateTime periodStart = _firstDay;
    DateTime periodEnd = _lastDay;

    final sessionState = sessionBloc.state;
    if (sessionState is SessionLoadedState) {
      final condominium = sessionState.session?.selectedCondominium;
      if (condominium != null) {
        add(ReservationCalendarLoadEvent(
            spaceId: spaceId,
            condominiumId: condominium.id,
            periodStart: periodStart,
            periodEnd: periodEnd));
      }
    }
  }

  final DateTime _firstDay = DateTime.now().firstDayOfMonth();
  @override
  DateTime getFirstDay() {
    //zerar hora minuto e segundo
    return DateTime(_firstDay.year, _firstDay.month, _firstDay.day, 0, 0, 0, 0);
  }

  final DateTime _lastDay = DateTime.now().add(const Duration(days: 365));
  @override
  DateTime getLastDay() {
    return _lastDay;
  }

  @override
  void beginLoadCalendarHistory() {
    DateTime periodStart = _firstDay;
    DateTime periodEnd = _lastDay;

    if (state is ReservationCalendarLoadingState &&
        state.periodStart == periodStart &&
        state.periodEnd == periodEnd) return;

    final sessionState = sessionBloc.state;
    if (sessionState is SessionLoadedState) {
      final condominium = sessionState.session?.selectedCondominium;
      if (condominium != null) {
        add(ReservationCalendarHistoryEvent(
            condominiumId: condominium.id,
            periodStart: periodStart,
            periodEnd: periodEnd));
      }
    } else {}
  }

  @override
  void beginLoadHours(DateTime date, String unitId, String spaceId) {
    final sessionState = sessionBloc.state;
    if (sessionState is SessionLoadedState) {
      final condominium = sessionState.session?.selectedCondominium;
      if (condominium != null) {
        add(
          ReservationCalendarLoadHoursEvent(
              unitId: unitId,
              spaceId: spaceId,
              condominiumId: condominium.id,
              date: date),
        );
      }
    }
  }

  @override
  void beginSendRegistration(String spaceId, Space space, String unitId,
      DateTime reservationStartDate, DateTime reservationEndDate) {
    final sessionState = sessionBloc.state;
    if (sessionState is SessionLoadedState) {
      final condominium = sessionState.session?.selectedCondominium;
      if (condominium != null) {
        add(CreateReservationEvent(
          spaceId: spaceId,
          space: space,
          unitId: unitId,
          condominiumId: condominium.id,
          reservationStartDate: reservationStartDate,
          reservationEndDate: reservationEndDate,
        ));
      }
    }
  }

  Stream<ReservationCalendarState> _mapDelete(DeleteEvent event) async* {
    final condominiumId = sessionBloc.state.session?.selectedCondominium?.id;
    final periodStart = DateTime.now();
    final periodEnd = DateTime.now();

    yield ReservationCalendarLoadingState(state.data!, [], periodStart,
        periodEnd, null, SpaceAvailableHours(), condominiumId!);

    final result = await delete.call(DeleteReservationParam(
        condominiumId: condominiumId,
        reservationId: event.reservationId!,
        reservationType: event.reservationType!));

    var response = result.fold(
        (err) => ReservationCalendarLoadFailedState(
            state.data!,
            [],
            periodStart,
            periodEnd,
            null,
            SpaceAvailableHours(),
            condominiumId,
            err),
        (res) => DeleteSucessState(
              state.data!,
              [],
              periodStart,
              periodEnd,
              null,
              SpaceAvailableHours(),
              condominiumId,
            ));
    yield response;
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  @override
  void deleteReservation(String reservationId, String reservationType) {
    add(DeleteEvent(
      reservationId: reservationId,
      reservationType: reservationType,
    ));
  }
}
