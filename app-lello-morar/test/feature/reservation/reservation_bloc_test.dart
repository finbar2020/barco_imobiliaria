import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/feature/billets/domain/use_case/billets_pdf_use_case.dart';
import 'package:morar/feature/documents/domain/entity/document_file.dart';
import 'package:morar/feature/reservation/domain/entity/reservatio_chargin.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_registration.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_rule.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_scheduled.dart';
import 'package:morar/feature/reservation/domain/entity/space.dart';
import 'package:morar/feature/reservation/domain/entity/space_available_hours.dart';
import 'package:morar/feature/reservation/domain/entity/space_calendar_response.dart';
import 'package:morar/feature/reservation/domain/entity/space_type.dart';
import 'package:morar/feature/reservation/domain/use_case/delete_reservation/delete_reservation.dart';
import 'package:morar/feature/reservation/domain/use_case/get_all_reservation/get_all_reservation.dart';
import 'package:morar/feature/reservation/domain/use_case/get_calendar/get_calendar.dart';
import 'package:morar/feature/reservation/domain/use_case/get_hours/get_hours.dart';
import 'package:morar/feature/reservation/domain/use_case/get_spaces/get_spaces.dart';
import 'package:morar/feature/reservation/domain/use_case/post_reservations/post_reservation.dart';
import 'package:morar/feature/reservation/presentation/bloc/reservation_bloc.dart';
import 'package:morar/feature/reservation/presentation/bloc/reservation_event.dart';
import 'package:morar/feature/reservation/presentation/bloc/reservation_state.dart';
import 'package:morar/feature/session/presentation/bloc/session_state.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/test_application_container.dart';

Space _space({String id = 'free', String type = 'A', bool chargeable = false, String name = 'salao', int minRange = 0}) =>
    Space()
      ..id = id
      ..name = name
      ..type = (SpaceType()..id = type)
      ..reservationRule = (ReservationRule()
        ..chargeable = chargeable
        ..reservationRangeMinimum = minRange);

ReservationScheduled _reservation({ReservationCharging? charging, String type = 'A'}) => ReservationScheduled()
  ..id = 1
  ..area = 'piscina'
  ..flagChargingForm = charging
  ..reservationType = type;

class _FakeGetSpace extends Fake implements GetSpace {
  _FakeGetSpace({this.fail = false});
  final bool fail;
  @override
  Future<Try<List<Space>>> call(GetSpaceParam params) async {
    if (fail) return Rejection(UnknownFailure('x'));
    return Success([
      _space(),
      _space(id: 'paid', type: 'B', chargeable: true, name: 'CHURRASQUEIRA'),
      _space(id: 'moving', type: 'M', name: 'Mudanca'),
      _space(id: 'late', minRange: 5),
    ]);
  }
}

class _FakeGetAll extends Fake implements GetAllReservation {
  @override
  Future<Try<List<ReservationScheduled>>> call(GetAllReservationParam params) async => Success([
        _reservation(),
        _reservation(charging: ReservationCharging.billet),
        _reservation(type: 'M'),
      ]);
}

class _FakeCalendar extends Fake implements GetCalendar {
  bool fail = false;
  @override
  Future<Try<SpaceCalendarResponse>> call(GetCalendarParam params) async {
    if (fail) return Rejection(UnknownFailure('x'));
    return Success(SpaceCalendarResponse()..freeToReserveDays = ['${params.startDate.day}']);
  }
}

class _FakeHours extends Fake implements GetHours {
  Failure? failure;
  @override
  Future<Try<List<SpaceAvailableHours>>> call(GetHoursParam params) async {
    if (failure != null) return Rejection(failure!);
    return Success([SpaceAvailableHours(from: '08', until: '10')]);
  }
}

class _FakePost extends Fake implements PostReservation {
  Failure? failure;
  @override
  Future<Try<ReservationScheduled>> call(PostReservationParam params) async {
    if (failure != null) return Rejection(failure!);
    return Success(_reservation(type: params.reservationRegistration.reservationType ?? 'A')..area = 'nova');
  }
}

class _FakeDelete extends Fake implements DeleteReservation {
  bool fail = false;
  @override
  Future<Try<String>> call(DeleteReservationParam params) async {
    if (fail) return Rejection(UnknownFailure('x'));
    return Success('ok');
  }
}

class _FakeBilletsPdf extends Fake implements BilletsPdfUseCase {
  _FakeBilletsPdf({this.fail = false});
  final bool fail;
  @override
  Future<Try<DocumentFile>> call(BilletsPdfParams params) async {
    if (fail) return Rejection(UnknownFailure('x'));
    return Success(DocumentFile(name: 'b.pdf'));
  }
}

void main() {
  late FakeSessionBloc sessionBloc;
  late _FakeGetSpace getSpace;
  late _FakeCalendar calendar;
  late _FakeHours hours;
  late _FakePost post;
  late _FakeDelete delete;

  setUpAll(() async {
    await setUpFakeFirebase();
  });

  setUp(() {
    sessionBloc = FakeSessionBloc();
    getSpace = _FakeGetSpace();
    calendar = _FakeCalendar();
    hours = _FakeHours();
    post = _FakePost();
    delete = _FakeDelete();
  });

  ReservationBloc build({bool failPdf = false}) => ReservationBloc(
        getSpace: getSpace,
        getReservations: _FakeGetAll(),
        sessionBloc: sessionBloc,
        hours: hours,
        calendar: calendar,
        insertReservation: post,
        delete: delete,
        billetsPdf: _FakeBilletsPdf(fail: failPdf),
      );

  Future<ReservationBloc> loaded() async {
    final bloc = build();
    addTearDown(bloc.close);
    await waitFor(() => bloc.state is LoadedSpaceState);
    return bloc;
  }

  test('carrega espaços e reservas com todos os rbacs', () async {
    final bloc = await loaded();
    expect(bloc.state.spaces.map((s) => s.name), ['Salao', 'Churrasqueira', 'Mudança', 'Salao']);
    expect(bloc.state.reservations!.map((r) => r.area), everyElement('Piscina'));
    expect(bloc.state.freeSpaces.map((s) => s.id), ['free', 'late']);
    expect(bloc.state.paidSpaces.single.id, 'paid');
    expect(bloc.state.movingSpaces.single.id, 'moving');
    expect(bloc.listSpaces, hasLength(4));
    expect(bloc.listReservations, hasLength(3));
    // Corrigido: "Mudanca" vira "Mudança" (o literal tinha encoding quebrado).
    expect(bloc.wordAdjust('Mudanca'), 'Mudança');
    expect(bloc.wordAdjust('ACADEMIA'), 'Academia');
  });

  test('rbacs filtram espaços e reservas', () async {
    sessionBloc.allowedRbacs = {ApplicationRbac.morarReservasAreasNovasReservasPagas, ApplicationRbac.morarReservasAreasAgendamentosPagas};
    final bloc = await loaded();
    expect(bloc.state.spaces.map((s) => s.id), ['paid']);
    expect(bloc.state.reservations!.single.flagChargingForm, ReservationCharging.billet);

    sessionBloc.allowedRbacs = {};
    bloc.getSpaces();
    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(bloc.state.spaces, isEmpty);
    expect(bloc.state.reservations, isEmpty);
  });

  test('falha ao carregar espaços e sessão sem condomínio', () async {
    getSpace = _FakeGetSpace(fail: true);
    final bloc = build();
    addTearDown(bloc.close);
    await waitFor(() => bloc.state is FailureSpaceState);

    final semCondo = FakeSessionBloc(session: testSession(me: testMe(condominiums: [testCondominium(id: 'c1')])));
    semCondo.session.condominium!.id = null;
    sessionBloc = semCondo;
    final bloc2 = build();
    addTearDown(bloc2.close);
    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(bloc2.state, isA<ReservationEmptyState>());
  });

  test('sessão ainda não carregada escuta o stream', () async {
    sessionBloc.currentState = const SessionInitialState();
    final bloc = build();
    expect(bloc.state, isA<ReservationEmptyState>());
    await bloc.close();
  });

  test('calendário, horas e limpeza', () async {
    final bloc = await loaded();
    bloc.getCalendar('free', DateTime(2026, 3, 1), DateTime(2026, 3, 31));
    await waitFor(() => bloc.state is LoadedCalendarState);
    var state = bloc.state as LoadedCalendarState;
    expect(state.calendarResponse.freeToReserveDays, ['1']);
    expect(state.hours, hasLength(1));
    expect(state.loadedHours, isTrue);
    expect(state.stateCreatedAt, isNotNull);

    bloc.getHours('c1', 'free', DateTime(2026, 3, 10));
    await waitFor(() => bloc.state is LoadedCalendarState && (bloc.state as LoadedCalendarState).selectedDate.day == 10 && (bloc.state as LoadedCalendarState).loadedHours);
    expect((bloc.state as LoadedCalendarState).hours, hasLength(1));

    hours.failure = KnownFailure('406', 'x');
    bloc.getHours('c1', 'free', DateTime(2026, 3, 11));
    await waitFor(() => bloc.state is LoadedCalendarState && (bloc.state as LoadedCalendarState).error != null);
    expect((bloc.state as LoadedCalendarState).hours, isEmpty);

    bloc.clearError(bloc.state as LoadedCalendarState);
    await waitFor(() => bloc.state is LoadedCalendarState && (bloc.state as LoadedCalendarState).error == null);

    bloc.clearHours(DateTime(2026, 3, 12));
    await waitFor(() => bloc.state is LoadedCalendarState && (bloc.state as LoadedCalendarState).selectedDate.day == 12);
    expect((bloc.state as LoadedCalendarState).hours, isEmpty);

    hours.failure = null;
    bloc.getCalendarMonth('free', DateTime(2026, 4, 1), DateTime(2026, 4, 30));
    await waitFor(() => bloc.state is LoadedCalendarState && (bloc.state as LoadedCalendarState).selectedDate.month == 4 && (bloc.state as LoadedCalendarState).loadedMonth);
    expect(bloc.hoursResponse, hasLength(1));

    hours.failure = UnknownFailure('x');
    bloc.getCalendarMonth('free', DateTime(2026, 5, 1), DateTime(2026, 5, 31));
    await waitFor(() => bloc.state is FailureCalendarState);
  });

  test('calendário limpa horas antes da data mínima e trata falhas', () async {
    final bloc = await loaded();
    bloc.getCalendar('late', DateTime(2026, 3, 1), DateTime(2026, 3, 31));
    await waitFor(() => bloc.state is LoadedCalendarState);
    expect((bloc.state as LoadedCalendarState).hours, isEmpty);

    calendar.fail = true;
    bloc.getCalendar('free', DateTime(2026, 3, 1), DateTime(2026, 3, 31));
    await waitFor(() => bloc.state is FailureCalendarState);
    bloc.getCalendarMonth('free', DateTime(2026, 3, 1), DateTime(2026, 3, 31));
    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(bloc.state, isA<FailureCalendarState>());
  });

  test('reserva: diálogo, envio com sucesso e falhas', () async {
    final bloc = await loaded();
    bloc.getCalendar('paid', DateTime(2026, 3, 1), DateTime(2026, 3, 31));
    await waitFor(() => bloc.state is LoadedCalendarState);
    final hour = SpaceAvailableHours(from: '08', until: '10');
    final paid = bloc.state.spaces.firstWhere((s) => s.id == 'paid');
    bloc.postSpace(paid, DateTime(2026, 3, 5), hour);
    await waitFor(() => bloc.state is LoadedDialogState);
    expect((bloc.state as LoadedDialogState).space.id, 'paid');

    fakeAnalytics.reset();
    final registration = ReservationRegistration(spaceId: 'paid', space: paid, reservationType: 'M', unitId: 'u1');
    bloc.postReservation(registration, DateTime(2026, 3, 5), hour);
    await waitFor(() => bloc.state is ReservationSendSuccessState);
    expect((bloc.state as ReservationSendSuccessState).reservation.area, 'nova');
    expect(fakeAnalytics.eventNames, containsAll(['morar_reservas_pagas_write', 'morar_reservas_mudancas_write', 'reservas_reservar']));

    final free = bloc.state.spaces.firstWhere((s) => s.id == 'free');
    bloc.getCalendar('free', DateTime(2026, 3, 1), DateTime(2026, 3, 31));
    await waitFor(() => bloc.state is LoadedCalendarState);
    fakeAnalytics.reset();
    bloc.postReservation(ReservationRegistration(spaceId: 'free', space: free), DateTime(2026, 3, 5), hour);
    await waitFor(() => bloc.state is ReservationSendSuccessState);
    expect(fakeAnalytics.eventNames, contains('morar_reservas_naopagas_write'));

    post.failure = KnownFailure('limite_reservas', 'x');
    bloc.getCalendar('free', DateTime(2026, 3, 1), DateTime(2026, 3, 31));
    await waitFor(() => bloc.state is LoadedCalendarState);
    bloc.postReservation(ReservationRegistration(spaceId: 'free', space: free), DateTime(2026, 3, 5), hour);
    await waitFor(() => bloc.state is FailureDialogState);
    expect((bloc.state as FailureDialogState).message, 'limite_reservas');

    post.failure = UnknownFailure('x');
    bloc.getCalendar('free', DateTime(2026, 3, 1), DateTime(2026, 3, 31));
    await waitFor(() => bloc.state is LoadedCalendarState);
    bloc.postReservation(ReservationRegistration(spaceId: 'free', space: free), DateTime(2026, 3, 5), hour);
    await waitFor(() => bloc.state is FailureDialogState);
    expect((bloc.state as FailureDialogState).message, 'reserves_reserve_not_possible');
  });

  testWidgets('cancelamento de reserva', (tester) async {
    await pumpApp(tester, const Text('x'));
    final context = tester.element(find.text('x'));
    // O bloc usa timers reais: precisa rodar fora do FakeAsync do tester.
    await tester.runAsync(() async {
      final bloc = await loaded();
      fakeAnalytics.reset();
      bloc.deleteReservation('1', 'A', context);
      await waitFor(() => bloc.state is ReservationDeletedState);
      expect(fakeAnalytics.eventNames, contains('reservas_cancelar'));

      delete.fail = true;
      bloc.deleteReservation('1', 'A', context);
      await waitFor(() => bloc.state is FailureSpaceState);
      expect(bloc.state.reservations, hasLength(3));
    });
  });

  test('downloadBillet e tabs', () async {
    final bloc = await loaded();
    final doc = await bloc.downloadBillet(billetNumber: '1');
    expect(doc!.name, 'b.pdf');
    final failed = build(failPdf: true);
    addTearDown(failed.close);
    expect(await failed.downloadBillet(billetNumber: '1'), isNull);
    bloc.animateToTab(1);
    expect(bloc.tabController, isNull);
  });

  test('estados auxiliares', () {
    final session = testSession();
    final loading = LoadingDialogState(
      calendarResponse: SpaceCalendarResponse(),
      selectedDate: DateTime(2026),
      spaces: [_space(), _space(id: 'p', chargeable: true)],
      session: session,
    );
    expect(loading.freeSpaces.single.id, 'free');
    expect(loading.paidSpaces.single.id, 'p');
    expect(loading.loadedHours, isTrue);
    expect(ReservationDeletedState(session: session, reservations: const []).reservations, isEmpty);
    expect(GetCalendarEvent(spaceId: 's', startDate: DateTime(2026), endDate: DateTime(2026)).props.length, 3);
    expect(GetHoursEvent(spaceId: 's', date: DateTime(2026), condominiumId: 'c').props.length, 3);
    expect(ClearHoursEvent(date: DateTime(2026)).props, [DateTime(2026)]);
  });
}
