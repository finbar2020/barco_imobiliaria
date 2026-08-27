import 'dart:async';

import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_filter.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_signature.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_type_enum.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_signatures/timesheet_signatures_bloc.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_signatures/timesheet_signatures_event.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_signatures/timesheet_signatures_state.dart';

import '../../../helpers/firebase_mocks.dart';
import 'timesheet_test_helpers.dart';

void main() {
  late TimesheetStack stack;
  final session = FakeSharedSession();
  TimesheetFilter filtro() => TimesheetFilter(
      type: TimesheetTypeEnum.events,
      dobFrom: DateTime(hoje.year, hoje.month, 1),
      dobTo: hoje);

  setUpAll(() async {
    await setUpFakeFirebase();
  });

  setUp(() {
    stack = TimesheetStack();
    fakeAnalytics.reset();
  });

  Future<List<TimesheetSignaturesState>> coletar(TimesheetSignaturesBloc bloc,
      bool Function(TimesheetSignaturesState) ate) async {
    final states = <TimesheetSignaturesState>[];
    final completer = Completer<void>();
    final sub = bloc.stream.listen((s) {
      states.add(s);
      if (ate(s) && !completer.isCompleted) completer.complete();
    });
    await completer.future.timeout(const Duration(seconds: 5));
    await sub.cancel();
    return states;
  }

  test('sem sessão começa em Loading sem carregar', () async {
    final bloc = stack.signaturesBloc();
    expect(bloc.state, isA<TimesheetSignaturesLoadingState>());
    expect(bloc.state.signatures, isEmpty);
    expect(bloc.state.listSign, isEmpty);
    await Future<void>.delayed(Duration.zero);
    expect(stack.http.requests, isEmpty);
    await bloc.close();
  });

  test('com sessão carrega as assinaturas e registra analytics', () async {
    stack.happyPath();
    final bloc = stack.signaturesBloc(session: session)..state.query = filtro();
    final states =
        await coletar(bloc, (s) => s is TimesheetSignaturesLoadedState);
    expect(states.map((s) => s.runtimeType).toList(),
        [TimesheetSignaturesLoadingState, TimesheetSignaturesLoadedState]);
    final loaded = states.last as TimesheetSignaturesLoadedState;
    expect(loaded.signatures.map((s) => s.id), [1, 2]);
    expect(loaded.donePaging, false);
    expect(loaded.condominiumId, 'C1');
    expect(stack.http.requests.single.url.queryParameters['type'], 'events');
    await Future<void>.delayed(Duration.zero);
    expect(fakeAnalytics.eventNames, contains('ponto_assinafolha_acessar'));
    await bloc.close();
  });

  test('falha ao carregar emite LoadFailed', () async {
    stack.http.failAll();
    final bloc = stack.signaturesBloc(
        session: session, origin: AppOriginEnum.employee)
      ..state.query = filtro();
    final states =
        await coletar(bloc, (s) => s is TimesheetSignaturesLoadFailedState);
    expect((states.last as TimesheetSignaturesLoadFailedState).error,
        isA<UnknownFailure>());
    await bloc.close();
  });

  test('sign e beginRefresh são ignorados durante o carregamento', () async {
    stack.happyPath();
    final bloc = stack.signaturesBloc(session: session)..state.query = filtro();
    bloc.sign();
    bloc.beginRefresh();
    await coletar(bloc, (s) => s is TimesheetSignaturesLoadedState);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(stack.http.requests.length, 1);
    await bloc.close();
  });

  test('sign assina os selecionados, registra analytics e recarrega',
      () async {
    stack.happyPath();
    final bloc = stack.signaturesBloc(session: session)..state.query = filtro();
    await coletar(bloc, (s) => s is TimesheetSignaturesLoadedState);
    bloc.state.listSign.add(bloc.state.signatures.first);

    bloc.sign();
    final states =
        await coletar(bloc, (s) => s is TimesheetSignaturesLoadedState);
    expect(states.map((s) => s.runtimeType).toList(), [
      TimesheetSigningState,
      TimesheetSignedState,
      TimesheetSignaturesLoadingState,
      TimesheetSignaturesLoadedState,
    ]);
    expect((states[1] as TimesheetSignedState).donePaging, true);
    final put = stack.http.requests.firstWhere((r) => r.method == 'PUT');
    expect(put.url.path, '/timesheet/signatures/C1');
    expect(put.body, contains('"id":1'));
    await Future<void>.delayed(Duration.zero);
    expect(fakeAnalytics.eventNames, contains('ponto_assinafolha_finalizado'));
    await bloc.close();
  });

  test('sign com erro na API emite SignFailed (origem employee)', () async {
    stack.happyPath();
    stack.http.on('PUT', '/timesheet/signatures/C1', status: 500);
    final bloc = stack.signaturesBloc(
        session: session, origin: AppOriginEnum.employee)
      ..state.query = filtro();
    await coletar(bloc, (s) => s is TimesheetSignaturesLoadedState);
    bloc.state.listSign.add(bloc.state.signatures.first);

    bloc.sign();
    final states = await coletar(bloc, (s) => s is TimesheetSignFailedState);
    expect(states.map((s) => s.runtimeType).toList(),
        [TimesheetSigningState, TimesheetSignFailedState]);
    expect((states.last as TimesheetSignFailedState).error,
        isA<UnknownFailure>());
    await bloc.close();
  });

  test('sign sem nada selecionado falha na validação sem chamar a API',
      () async {
    stack.happyPath();
    final bloc = stack.signaturesBloc(session: session)..state.query = filtro();
    await coletar(bloc, (s) => s is TimesheetSignaturesLoadedState);

    bloc.add(const TimesheetSignEvent());
    final states = await coletar(bloc, (s) => s is TimesheetSignFailedState);
    expect((states.last as TimesheetSignFailedState).error,
        isA<InvalidParamFailure>());
    expect(stack.http.requests.where((r) => r.method == 'PUT'), isEmpty);
    await bloc.close();
  });

  test('eventos e estados têm igualdade por props', () {
    expect(const TimesheetSignEvent().props, isEmpty);
    expect(const TimesheetSignaturesLoadEvent(condominiumId: 'a'),
        const TimesheetSignaturesLoadEvent(condominiumId: 'a'));
    final sigs = [TimesheetSignature(id: 1)];
    final sel = <TimesheetSignature>[];
    final query = TimesheetFilter();
    final month = DateTime(2026, 8);
    final err = UnknownFailure('x');
    expect(TimesheetSignaturesLoadingState(null, sel, null, null, null)
        .signatures, isEmpty);
    expect(
        TimesheetSignaturesLoadFailedState(sigs, sel, query, 'C1', month, err)
            .props,
        [sigs, sel, query, 'C1', month, err]);
    expect(TimesheetSignaturesLoadedState(sigs, sel, query, 'C1', month, true)
        .props.last, true);
    expect(TimesheetSigningState(sigs, sel, query, 'C1', month).props,
        [sigs, sel, query, 'C1', month]);
    expect(TimesheetSignFailedState(sigs, sel, query, 'C1', month, err)
        .props.last, err);
    expect(TimesheetSignedState(sigs, sel, query, 'C1', month, false)
        .props.last, false);
  });
}
