import 'dart:async';

import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_event.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_filter.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_type_enum.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_list/timesheet_list_bloc.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_list/timesheet_list_event.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_list/timesheet_list_state.dart';

import '../../../helpers/firebase_mocks.dart';
import 'timesheet_test_helpers.dart';

void main() {
  late TimesheetStack stack;
  final session = FakeSharedSession();
  TimesheetFilter filtro() => TimesheetFilter(
      type: TimesheetTypeEnum.present, dobFrom: hoje, dobTo: hoje);

  setUpAll(() async {
    await setUpFakeFirebase();
  });

  setUp(() {
    stack = TimesheetStack();
    fakeAnalytics.reset();
  });

  Future<List<TimesheetListState>> coletar(
      TimesheetListBloc bloc, bool Function(TimesheetListState) ate) async {
    final states = <TimesheetListState>[];
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
    final bloc = stack.listBloc();
    expect(bloc.state, isA<TimesheetListLoadingState>());
    expect(bloc.state.list, isEmpty);
    expect(bloc.state.query, isNull);
    await Future<void>.delayed(Duration.zero);
    expect(stack.http.requests, isEmpty);
    await bloc.close();
  });

  test('com sessão e filtro carrega a lista e registra analytics (manager)',
      () async {
    stack.happyPath();
    final bloc = stack.listBloc(session: session)..state.query = filtro();
    final states = await coletar(bloc, (s) => s is TimesheetListLoadedState);

    expect(states.map((s) => s.runtimeType).toList(),
        [TimesheetListLoadingState, TimesheetListLoadedState]);
    final loaded = states.last as TimesheetListLoadedState;
    expect(loaded.condominiumId, 'C1');
    expect(loaded.list.single.employee!.name, 'Maria Silva');
    expect(loaded.donePaging, false);
    final req = stack.http.requests.single;
    expect(req.url.path, '/timesheet/references/C1');
    expect(req.url.queryParameters['type'], 'present');
    await Future<void>.delayed(Duration.zero);
    expect(fakeAnalytics.eventNames, contains('ponto_acao_ocorrencia_acessar'));
    expect(fakeAnalytics.events['ponto_acao_ocorrencia_acessar'], {
      'tipo': 'read',
      'referencia': 'R1',
      'unidade': '101',
    });
    await bloc.close();
  });

  test('origem employee também registra o acesso', () async {
    stack.happyPath(timesheets: []);
    final bloc = stack.listBloc(session: session, origin: AppOriginEnum.employee)
      ..state.query = filtro();
    final states = await coletar(bloc, (s) => s is TimesheetListLoadedState);
    expect((states.last as TimesheetListLoadedState).donePaging, true);
    await Future<void>.delayed(Duration.zero);
    expect(fakeAnalytics.eventNames, contains('ponto_acao_ocorrencia_acessar'));
    await bloc.close();
  });

  test('falha ao carregar emite LoadFailed', () async {
    stack.http.failAll();
    final bloc = stack.listBloc(session: session)..state.query = filtro();
    final states =
        await coletar(bloc, (s) => s is TimesheetListLoadFailedState);
    final failed = states.last as TimesheetListLoadFailedState;
    expect(failed.error, isA<UnknownFailure>());
    expect(failed.list, isEmpty);
    expect(failed.condominiumId, 'C1');
    await bloc.close();
  });

  test('beginRefresh recarrega só quando não está carregando', () async {
    stack.happyPath();
    final bloc = stack.listBloc(session: session)..state.query = filtro();
    bloc.beginRefresh(); // ignorado: ainda em Loading
    await coletar(bloc, (s) => s is TimesheetListLoadedState);
    expect(stack.http.requests.length, 1);

    bloc.beginRefresh();
    await coletar(bloc, (s) => s is TimesheetListLoadedState);
    expect(stack.http.requests.length, 2);
    await bloc.close();
  });

  test('insertEvent é ignorado durante o carregamento', () async {
    stack.happyPath();
    final bloc = stack.listBloc(session: session)..state.query = filtro();
    bloc.insertEvent(TimesheetEvent(typeEvent: 'ABONO', effectiveDate: hoje));
    await coletar(bloc, (s) => s is TimesheetListLoadedState);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(stack.http.requests.map((r) => r.method), ['GET']);
    await bloc.close();
  });

  /// Defeito: `_mapInsert` usa `state.event!`, mas nenhum estado do fluxo
  /// normal recebe `event` (sempre `null`). Inserir uma ocorrência a partir de
  /// um estado carregado pelo próprio bloc explode com "Null check operator"
  /// antes de chamar a API, e nada é emitido.
  test('insertEvent após o carregamento normal explode (defeito)', () async {
    stack.happyPath();
    final errors = <Object>[];
    late TimesheetListBloc bloc;
    await runZonedGuarded(() async {
      bloc = stack.listBloc(session: session)..state.query = filtro();
      await coletar(bloc, (s) => s is TimesheetListLoadedState);
      bloc.insertEvent(
          TimesheetEvent(typeEvent: 'ABONO', effectiveDate: hoje));
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }, (e, _) => errors.add(e));

    expect(errors.first, isA<TypeError>());
    expect(bloc.state, isA<TimesheetListLoadedState>());
    expect(stack.http.requests.map((r) => r.method), ['GET']);
    await bloc.close();
  });

  test('insertEvent com estado que tem evento insere, registra e recarrega',
      () async {
    stack.happyPath();
    final bloc = stack.listBloc(session: session)..state.query = filtro();
    await coletar(bloc, (s) => s is TimesheetListLoadedState);
    // ignore: invalid_use_of_visible_for_testing_member
    bloc.emit(TimesheetListLoadedState(bloc.state.list,
        const TimesheetListLoadEvent(), filtro(), 'C1', hoje, false));

    bloc.insertEvent(TimesheetEvent(
        typeEvent: 'ABONO', effectiveDate: hoje, registrationNumber: 'E1'));
    final states = await coletar(bloc, (s) => s is TimesheetListLoadedState);
    expect(states.map((s) => s.runtimeType).toList(), [
      TimesheetInsertingState,
      TimesheetInsertedState,
      TimesheetListLoadingState,
      TimesheetListLoadedState,
    ]);
    expect((states.first as TimesheetInsertingState).selectedDate, hoje);
    expect((states[1] as TimesheetInsertedState).donePaging, true);
    final post = stack.http.requests.firstWhere((r) => r.method == 'POST');
    expect(post.url.path, '/timesheet/event/C1');
    await Future<void>.delayed(Duration.zero);
    expect(fakeAnalytics.eventNames,
        contains('ponto_acao_ocorrencia_finalizado'));
    expect(fakeAnalytics.events['ponto_acao_ocorrencia_finalizado']!['tipo'],
        'Descontou ou abonou ocorrencia');
    await bloc.close();
  });

  test('insertEvent com erro na API emite InsertFailed (origem employee)',
      () async {
    stack.happyPath();
    stack.http.on('POST', '/timesheet/event/C1', status: 500);
    final bloc = stack.listBloc(session: session, origin: AppOriginEnum.employee)
      ..state.query = filtro();
    await coletar(bloc, (s) => s is TimesheetListLoadedState);
    // ignore: invalid_use_of_visible_for_testing_member
    bloc.emit(TimesheetListLoadedState(bloc.state.list,
        const TimesheetListLoadEvent(), filtro(), 'C1', hoje, false));

    bloc.insertEvent(TimesheetEvent(typeEvent: 'ABONO', effectiveDate: hoje));
    final states =
        await coletar(bloc, (s) => s is TimesheetInsertFailedState);
    expect(states.map((s) => s.runtimeType).toList(),
        [TimesheetInsertingState, TimesheetInsertFailedState]);
    expect((states.last as TimesheetInsertFailedState).error,
        isA<UnknownFailure>());
    await bloc.close();
  });

  test('eventos e estados têm igualdade por props', () {
    final ev = TimesheetEvent(id: '1');
    expect(TimesheetListInsertEvent(timesheetEvent: ev).props, [ev]);
    expect(const TimesheetListLoadEvent(condominiumId: 'a'),
        const TimesheetListLoadEvent(condominiumId: 'a'));
    final list = [Timesheet()];
    final query = TimesheetFilter();
    final month = DateTime(2026, 8);
    final err = UnknownFailure('x');
    const event = TimesheetListLoadEvent();
    expect(TimesheetListLoadingState(null, null, null, null, month).list, isEmpty);
    expect(TimesheetListLoadFailedState(list, event, query, 'C1', month, err)
        .props, [list, event, query, 'C1', month, err]);
    expect(TimesheetListLoadedState(list, event, query, 'C1', month, true)
        .props.last, true);
    expect(TimesheetInsertingState(list, event, query, 'C1', month, month)
        .props.last, month);
    expect(TimesheetInsertFailedState(list, event, query, 'C1', month, err)
        .props.last, err);
    expect(TimesheetInsertedState(list, event, query, 'C1', month, false)
        .props.last, false);
    expect(TimesheetInsertedState(list, event, query, 'C1', month, false),
        TimesheetInsertedState(list, event, query, 'C1', month, false));
  });
}
