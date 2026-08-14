import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/feature/billets/domain/use_case/billets_pdf_use_case.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_registration.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_scheduled.dart';
import 'package:morar/feature/reservation/domain/entity/space.dart';
import 'package:morar/feature/reservation/domain/entity/space_available_hours.dart';
import 'package:morar/feature/reservation/domain/entity/space_calendar_response.dart';
import 'package:morar/feature/reservation/domain/use_case/delete_reservation/delete_reservation.dart';
import 'package:morar/feature/reservation/domain/use_case/get_all_reservation/get_all_reservation.dart';
import 'package:morar/feature/reservation/domain/use_case/get_calendar/get_calendar.dart';
import 'package:morar/feature/reservation/domain/use_case/get_hours/get_hours.dart';
import 'package:morar/feature/reservation/domain/use_case/get_spaces/get_spaces.dart';
import 'package:morar/feature/reservation/domain/use_case/post_reservations/post_reservation.dart';
import 'package:morar/feature/reservation/presentation/bloc/reservation_event.dart';
import 'package:morar/feature/reservation/presentation/bloc/reservation_state.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/session/presentation/bloc/session_state.dart';

import '../../../documents/domain/entity/document_file.dart';

class ReservationBloc extends Bloc<ReservationEvent, ReservationState> {
  final GetSpace getSpace;
  final GetAllReservation getReservations;
  final GetCalendar calendar;
  final GetHours hours;
  final PostReservation insertReservation;
  final DeleteReservation delete;
  final SessionBloc sessionBloc;
  final BilletsPdfUseCase billetsPdf;

  StreamSubscription? _subscription;

  TabController? tabController;

  ReservationBloc({
    required this.getSpace,
    required this.getReservations,
    required this.sessionBloc,
    required this.hours,
    required this.calendar,
    required this.insertReservation,
    required this.delete,
    required this.billetsPdf,
  }) : super(ReservationEmptyState()) {
    on<GetSpacesEvent>(_mapGetSpaces);
    on<GetCalendarEvent>(_mapGetCalendar);
    on<GetCalendarMonthEvent>(_mapGetCalendarMonth);
    on<GetHoursEvent>(_mapGetHours);
    on<PostFreeSpaceEvent>(_mapPostFreeSpace);
    on<PostReservationEvent>(_mapPostReservation);
    on<DeleteReservationEvent>(_mapDeleteReservation);
    on<ClearHoursEvent>(_mapClearHour);
    on<ClearErrorEvent>(_mapClearError);
    if (this.sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(this.sessionBloc.state);
    } else {
      _subscription = this.sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  SpaceCalendarResponse? calendarResponse;
  List<SpaceAvailableHours>? hoursResponse;
  DateTime? selectedDate;
  List<Space> listSpaces = [];
  List<ReservationScheduled> listReservations = [];

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  Future<void> _mapGetSpaces(
    GetSpacesEvent event,
    Emitter<ReservationState> emit,
  ) async {
    emit(LoadingSpaceState());

    if (sessionBloc.state.session?.condominium?.id == null) {
      emit(ReservationEmptyState());
      return;
    }

    final results = await Future.wait([
      getSpace.call(GetSpaceParam(
        condominiumId: sessionBloc.state.session!.condominium!.id!,
      )),
      getReservations.call(
        GetAllReservationParam(
          condominiumId: sessionBloc.state.session!.condominium!.id!,
          unitId: sessionBloc.state.session!.unity!.id!,
        ),
      ),
    ]);

    final listSpacesResult = results[0];
    final listReservationsResult = results[1];

    emit(listSpacesResult
        .foldAlong(listReservationsResult, (err) => FailureSpaceState(),
            (spaces, reservations) {
      //Spaces - rbac
      state.spaces = spaces as List<Space>;
      state.spaces.forEach((element) {
        element.name = wordAdjust(element.name!);
      });
      if (!sessionBloc.checkRback(
          ApplicationRbac.morarReservasAreasNovasReservasGratuitas)) {
        state.spaces.removeWhere((element) =>
            element.reservationRule.chargeable == false &&
            element.type!.id != "M");
      }
      if (!sessionBloc
          .checkRback(ApplicationRbac.morarReservasAreasNovasReservasPagas)) {
        state.spaces.removeWhere(
            (element) => element.reservationRule.chargeable == true);
      }

      if (!sessionBloc
          .checkRback(ApplicationRbac.morarReservasMudancasNovasReservas)) {
        state.spaces.removeWhere((element) => element.type!.id == "M");
      }

      //Reservations - rbac
      state.reservations = reservations as List<ReservationScheduled>;
      state.reservations!.forEach((element) {
        element.area = wordAdjust(element.area!);
      });
      if (!sessionBloc
          .checkRback(ApplicationRbac.morarReservasAreasAgendamentosPagas)) {
        state.reservations!
            .removeWhere((element) => element.flagChargingForm != null);
      }
      if (!sessionBloc.checkRback(
          ApplicationRbac.morarReservasAreasAgendamentosGratuitas)) {
        state.reservations!
            .removeWhere((element) => element.flagChargingForm == null);
      }
      if (!sessionBloc
          .checkRback(ApplicationRbac.morarReservasMudancasAgendamentos)) {
        state.reservations!
            .removeWhere((element) => element.reservationType == "M");
      }
      listSpaces = state.spaces;
      listReservations = state.reservations ?? listReservations;
      return LoadedSpaceState(
        spaces: state.spaces,
        reservations: state.reservations!,
        session: sessionBloc.state.session!,
      );
    }));
  }

  Future<void> _mapGetCalendar(
    GetCalendarEvent event,
    Emitter<ReservationState> emit,
  ) async {
    emit(LoadingCalendarState(
      spaces: state.spaces,
      reservations: state.reservations!,
      session: sessionBloc.state.session!,
    ));

    final results = await Future.wait([
      calendar.call(GetCalendarParam(
        condominiumId: sessionBloc.state.session!.condominium!.id!,
        spaceId: event.spaceId,
        startDate: event.startDate,
        endDate: event.endDate,
      )),
      hours.call(GetHoursParam(
        condominiumId: sessionBloc.state.session!.condominium!.id!,
        spaceId: event.spaceId,
        date: DateTime.now(),
        unitId: sessionBloc.state.session!.unity!.id!,
      )),
    ]);

    final calendarResult = results[0];
    final hourResult = results[1];

    emit(calendarResult.fold(
        (err) => FailureCalendarState(
              spaces: state.spaces,
              reservations: state.reservations!,
              session: sessionBloc.state.session!,
            ), (res) {
      calendarResponse = res as SpaceCalendarResponse;
      hoursResponse =
          hourResult.fold((l) => [], (r) => r as List<SpaceAvailableHours>);
      //clear hours by minDate
      if (DateTime.now().isBefore(state.spaces
          .firstWhere((element) => element.id == event.spaceId)
          .reservationRule
          .getMinReservationDate)) {
        hoursResponse = [];
      }
      return LoadedCalendarState(
          calendarResponse: calendarResponse!,
          hours: hoursResponse!,
          spaces: state.spaces,
          reservations: state.reservations!,
          session: sessionBloc.state.session!,
          selectedDate: selectedDate ?? DateTime.now());
    }));
  }

  Future<void> _mapGetCalendarMonth(
    GetCalendarMonthEvent event,
    Emitter<ReservationState> emit,
  ) async {
    emit(LoadedCalendarState(
      spaces: state.spaces,
      reservations: state.reservations!,
      session: sessionBloc.state.session!,
      calendarResponse: calendarResponse!,
      hours: hoursResponse!,
      loadedHours: false,
      loadedMonth: false,
      selectedDate: event.startDate,
    ));

    final results = await Future.wait([
      calendar.call(GetCalendarParam(
        condominiumId: sessionBloc.state.session!.condominium!.id!,
        spaceId: event.spaceId,
        startDate: event.startDate,
        endDate: event.endDate,
      )),
      hours.call(GetHoursParam(
        condominiumId: sessionBloc.state.session!.condominium!.id!,
        spaceId: event.spaceId,
        date: DateTime.now(),
        unitId: sessionBloc.state.session!.unity!.id!,
      )),
    ]);

    final calendarResult = results[0];
    final hourResult = results[1];

    emit(calendarResult.foldAlong(
        hourResult,
        (err) => FailureCalendarState(
              spaces: state.spaces,
              reservations: state.reservations!,
              session: sessionBloc.state.session!,
            ), (calendar, hours) {
      calendarResponse = calendar as SpaceCalendarResponse;
      hoursResponse = hours as List<SpaceAvailableHours>;
      return LoadedCalendarState(
        spaces: state.spaces,
        reservations: state.reservations!,
        session: sessionBloc.state.session!,
        calendarResponse: calendar,
        hours: hours,
        selectedDate: event.startDate,
      );
    }));
  }

  Future<void> _mapGetHours(
    GetHoursEvent event,
    Emitter<ReservationState> emit,
  ) async {
    emit(LoadedCalendarState(
      calendarResponse: calendarResponse!,
      hours: hoursResponse!,
      loadedHours: false,
      spaces: state.spaces,
      reservations: state.reservations!,
      session: sessionBloc.state.session!,
      selectedDate: event.date,
    ));
    final response = await hours.call(GetHoursParam(
      condominiumId: sessionBloc.state.session!.condominium!.id!,
      spaceId: event.spaceId,
      date: event.date,
      unitId: sessionBloc.state.session!.unity!.id!,
    ));

    final result = response.fold((error) {
      return LoadedCalendarState(
          calendarResponse: calendarResponse!,
          selectedDate: event.date,
          hours: [],
          spaces: state.spaces,
          reservations: state.reservations!,
          session: sessionBloc.state.session!,
          error: error);
    }, (res) {
      try {
        hoursResponse = res;
        return LoadedCalendarState(
          calendarResponse: calendarResponse!,
          selectedDate: event.date,
          hours: res,
          spaces: state.spaces,
          reservations: state.reservations!,
          session: sessionBloc.state.session!,
        );
      } catch (e) {
        return FailureCalendarState(
          spaces: state.spaces,
          reservations: state.reservations!,
          session: sessionBloc.state.session!,
        );
      }
    });
    emit(result);
  }

  Future<void> _mapPostFreeSpace(
    PostFreeSpaceEvent event,
    Emitter<ReservationState> emit,
  ) async {
    emit(LoadedDialogState(
      spaces: state.spaces,
      session: sessionBloc.state.session!,
      selectedDate: event.reserveDate,
      calendarResponse: calendarResponse!,
      reserveDate: event.reserveDate,
      space: event.space,
      hours: hoursResponse!,
      hour: event.hour,
      reservations: state.reservations!,
    ));
  }

  Future<void> _mapPostReservation(
    PostReservationEvent event,
    Emitter<ReservationState> emit,
  ) async {
    emit(LoadingDialogState(
      calendarResponse: calendarResponse!,
      selectedDate: event.reserveDate!,
      hours: hoursResponse!,
      spaces: state.spaces,
      reservations: state.reservations,
      session: sessionBloc.state.session,
    ));

    final response = await insertReservation.call(PostReservationParam(
      condominiumId: sessionBloc.state.session!.condominium!.id!,
      spaceId: event.model.spaceId!,
      reservationRegistration: event.model,
    ));

    final result = response.fold((error) {
      String messageKey = "reserves_reserve_not_possible";
      if (error is KnownFailure && error.code != null) {
        messageKey = error.code!;
      }
      return FailureDialogState(
        calendarResponse: calendarResponse!,
        hours: hoursResponse!,
        spaces: state.spaces,
        reservations: state.reservations!,
        session: sessionBloc.state.session!,
        selectedDate: event.reserveDate!,
        message: messageKey,
      );
    }, (res) {
      try {
        if (event.model.space!.reservationRule.chargeable!) {
          FirebaseAnalytics.instance.logEvent(
            name: "morar_reservas_pagas_write",
            parameters: {
              "Tipo": "write",
              "Ãrea": res.area ?? "",
            },
          );
        }
        if (event.model.space!.reservationRule.chargeable == false) {
          FirebaseAnalytics.instance.logEvent(
            name: "morar_reservas_naopagas_write",
            parameters: {
              "Tipo": "write",
              "Ãrea": res.area ?? "",
            },
          );
        }
        if (res.reservationType == "M") {
          FirebaseAnalytics.instance.logEvent(
            name: "morar_reservas_mudancas_write",
            parameters: {
              "Tipo": "write",
              "Ãrea": res.area ?? "",
            },
          );
        }
        OwnerAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsOwner.reservasReservar(),
          userId: sessionBloc.state.session?.me?.id ?? "",
          unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
          referenceValue:
              sessionBloc.state.session!.condominium?.reference?.toString() ??
                  "",
        );
        return ReservationSendSuccessState(res, event.model.space,
            reservations: state.reservations,
            session: sessionBloc.state.session,
            spaces: state.spaces);
      } catch (e) {
        return FailureDialogState(
          calendarResponse: calendarResponse!,
          hours: hoursResponse!,
          spaces: state.spaces,
          reservations: state.reservations!,
          session: sessionBloc.state.session!,
          selectedDate: event.reserveDate!,
        );
      }
    });
    emit(result);
  }

  Future<void> _mapDeleteReservation(
    DeleteReservationEvent event,
    Emitter<ReservationState> emit,
  ) async {
    emit(LoadingSpaceState(
        spaces: state.spaces, reservations: state.reservations));

    final response = await delete.call(DeleteReservationParam(
      condominiumId: sessionBloc.state.session!.condominium!.id!,
      reservationId: event.reservationId,
      reservationType: event.reservationType,
    ));

    final result = response.fold(
        (error) => FailureSpaceState(
              spaces: state.spaces,
              reservations: state.reservations,
              session: sessionBloc.state.session,
            ), (res) {
      OwnerAnalyticsLogEvents.logEvent(
        event: AnalyticsEventsOwner.reservasCancelar(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
        referenceValue:
            sessionBloc.state.session!.condominium?.reference?.toString() ?? "",
      );
      return ReservationDeletedState(
          session: sessionBloc.state.session!,
          reservations: state.reservations ?? []);
    });

    emit(result);
  }

  Future<void> _mapClearHour(
    ClearHoursEvent event,
    Emitter<ReservationState> emit,
  ) async {
    emit(LoadedCalendarState(
      calendarResponse: calendarResponse!,
      hours: [],
      spaces: state.spaces,
      reservations: state.reservations!,
      session: sessionBloc.state.session!,
      selectedDate: event.date,
    ));
  }

  Future<void> _mapClearError(
    ClearErrorEvent event,
    Emitter<ReservationState> emit,
  ) async {
    emit(LoadedCalendarState(
      calendarResponse: event.state.calendarResponse,
      hours: event.state.hours,
      spaces: event.state.spaces,
      reservations: event.state.reservations!,
      session: sessionBloc.state.session!,
      selectedDate: event.state.selectedDate,
      loadedHours: event.state.loadedHours,
      loadedMonth: event.state.loadedMonth,
    ));
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState) {
      add(GetSpacesEvent());
    }
  }

  void getCalendar(String spaceId, DateTime startDate, DateTime endDate) {
    add(GetCalendarEvent(
      spaceId: spaceId,
      startDate: startDate,
      endDate: endDate,
    ));
  }

  void getHours(String condominiumId, String spaceId, DateTime date) {
    add(GetHoursEvent(
      condominiumId: condominiumId,
      spaceId: spaceId,
      date: date,
    ));
  }

  void clearHours(DateTime date) {
    if (state is LoadedCalendarState) {
      add(ClearHoursEvent(date: date));
    }
  }

  void postSpace(Space space, DateTime date, SpaceAvailableHours hour) {
    add(PostFreeSpaceEvent(space: space, reserveDate: date, hour: hour));
  }

  void postReservation(
      ReservationRegistration model, DateTime date, SpaceAvailableHours hour) {
    add(PostReservationEvent(
      model: model,
      reserveDate: date,
      hour: hour,
    ));
  }

  void getCalendarMonth(String spaceId, DateTime startDate, DateTime endDate) {
    add(GetCalendarMonthEvent(
      spaceId: spaceId,
      startDate: startDate,
      endDate: endDate,
    ));
  }

  void deleteReservation(
      String reservationId, String reservationType, BuildContext context) {
    add(DeleteReservationEvent(
      reservationId: reservationId,
      reservationType: reservationType,
      context: context,
    ));
  }

  String wordAdjust(String word) {
    if (word == 'Mudanca') {
      return "MudanÃ§a";
    }
    String text = word.toLowerCase();
    return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
  }

  void clearError(LoadedCalendarState state) {
    add(ClearErrorEvent(state: state));
  }

  void getSpaces() {
    add(GetSpacesEvent());
  }

  Future<DocumentFile?> downloadBillet({required String billetNumber}) async {
    final response =
        await billetsPdf.call(BilletsPdfParams(nrBillet: billetNumber));

    return response.fold((l) => null, (res) async {
      if (res.data != null && res.name != null) {
        Uint8List bytes = base64.decode(res.data!);
        String dir = (await getApplicationDocumentsDirectory()).path;
        File file = File("$dir/" + res.name!);
        await file.writeAsBytes(bytes);
      }
      return res;
    });
  }

  void setTabController(TabController controller) {
    this.tabController = controller;
  }

  void animateToTab(int i) {
    this.tabController?.animateTo(i);
  }
}
