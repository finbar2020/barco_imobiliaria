import 'dart:async';

import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_calendar/reservation_calendar_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_calendar/reservation_calendar_state.dart';

class ReservationCalendarBloc
    extends Bloc<ReservationCalendarEvent, ReservationCalendarState> {
  final SessionBloc sessionBloc;
  final ListReservationSummary listReservationSummary;
  final ListReservation listReservation;
  final ListAllReservation listAllReservation;
  final RegisterReservation registerReservation;
  final DeleteReservation delete;

  StreamSubscription? _subscription;

  ReservationCalendarBloc({
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
    on<ReservationCalendarLoadEvent>(_mapLoad);
    on<ReservationCalendarLoadHoursEvent>(_mapLoadHours);
    on<CreateReservationEvent>(_mapSendRegistration);
    on<ReservationCalendarHistoryEvent>(_mapLoadHistory);
    on<DeleteEvent>(_mapDelete);
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  void dispose() {
    _subscription?.cancel();
  }

  Future<void> _mapSendRegistration(
    CreateReservationEvent event,
    Emitter<ReservationCalendarState> emit,
  ) async {
    final condominiumId = event.condominiumId;

    emit(ReservationCalendarLoadingState(
        state.data,
        state.availableHours,
        state.periodStart,
        state.periodEnd,
        state.selectedDay,
        state.selectedHours,
        condominiumId));

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

    emit(resultYield);
  }

  Future<void> _mapLoadHistory(
    ReservationCalendarHistoryEvent event,
    Emitter<ReservationCalendarState> emit,
  ) async {
    final condominiumId = event.condominiumId;
    final periodStart = event.periodStart;
    final periodEnd = event.periodEnd;

    emit(ReservationCalendarLoadingState(state.data!, [], periodStart!,
        periodEnd!, null, SpaceAvailableHours(), condominiumId!));

    final result = await listAllReservation.call(ListAllReservationParam(
        condominiumId: condominiumId,
        startDate: periodStart,
        endDate: periodEnd));

    emit(result.fold(
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
    }));
  }

  Future<void> _mapLoad(
    ReservationCalendarLoadEvent event,
    Emitter<ReservationCalendarState> emit,
  ) async {
    final condominiumId = event.condominiumId;
    final periodStart = event.periodStart;
    final periodEnd = event.periodEnd;

    var data = state.data!;

    emit(ReservationCalendarLoadingState(data, [], periodStart!, periodEnd!,
        null, SpaceAvailableHours(), condominiumId!));

    final result = await listReservationSummary.call(
        ListReservationSummaryParam(
            spaceId: event.spaceId!,
            condominiumId: condominiumId,
            periodStart: periodStart,
            periodEnd: periodEnd,
            origin: DataOrigin.remote));
    emit(result.fold(
        (err) => ReservationCalendarLoadFailedState(data, [], periodStart,
            periodEnd, null, SpaceAvailableHours(), condominiumId, err),
        (data) => ReservationCalendarLoadedState(data, [], periodStart,
            periodEnd, null, SpaceAvailableHours(), condominiumId)));
  }

  Future<void> _mapLoadHours(
    ReservationCalendarLoadHoursEvent event,
    Emitter<ReservationCalendarState> emit,
  ) async {
    final condominiumId = event.condominiumId;
    final date = event.date;

    var data = state.data;
    emit(ReservationCalendarHoursLoadingState(
      data,
      [],
      state.periodStart,
      state.periodEnd,
      date,
      state.selectedHours,
      condominiumId!,
    ));

    final result = await listReservation.call(ListReservationParam(
        condominiumId: condominiumId,
        unitId: event.unitId!,
        spaceId: event.spaceId!,
        date: date!));

    emit(result.fold((err) {
      if (err is UnitExceededReservationLimit) {
        return ReservationUnitExceededFailedState(
            data!,
            [],
            state.periodStart,
            state.periodEnd,
            date,
            state.selectedHours,
            condominiumId,
            err);
      }
      return ReservationCalendarLoadFailedState(
          data!,
          [],
          state.periodStart!,
          state.periodEnd!,
          date,
          state.selectedHours!,
          condominiumId,
          err);
    },
        (res) => ReservationCalendarLoadedState(
            data,
            res,
            state.periodStart,
            state.periodEnd,
            date,
            state.selectedHours,
            condominiumId)));
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState) {
      beginLoadCalendarHistory();
    }
  }

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
  DateTime getFirstDay() {
    //zerar hora minuto e segundo
    return DateTime(_firstDay.year, _firstDay.month, _firstDay.day, 0, 0, 0, 0);
  }

  final DateTime _lastDay = DateTime.now().add(const Duration(days: 365));
  DateTime getLastDay() {
    return _lastDay;
  }

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

  Future<void> _mapDelete(
    DeleteEvent event,
    Emitter<ReservationCalendarState> emit,
  ) async {
    final condominiumId = sessionBloc.state.session?.selectedCondominium?.id;
    final periodStart = DateTime.now();
    final periodEnd = DateTime.now();

    emit(ReservationCalendarLoadingState(state.data!, [], periodStart,
        periodEnd, null, SpaceAvailableHours(), condominiumId!));

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
    emit(response);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  void deleteReservation(String reservationId, String reservationType) {
    add(DeleteEvent(
      reservationId: reservationId,
      reservationType: reservationType,
    ));
  }
}
