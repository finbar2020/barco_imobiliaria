import 'dart:async';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_filter.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_report_day.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_menu/timesheet_menu_bloc.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_menu/timesheet_menu_event.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_menu/timesheet_menu_state.dart';

import 'timesheet_test_helpers.dart';

void main() {
  late TimesheetStack stack;
  final session = FakeSharedSession();

  setUp(() {
    stack = TimesheetStack();
  });

  Future<List<TimesheetMenuState>> coletar(
      TimesheetMenuBloc bloc, bool Function(TimesheetMenuState) ate) async {
    final states = <TimesheetMenuState>[];
    final completer = Completer<void>();
    final sub = bloc.stream.listen((s) {
      states.add(s);
      if (ate(s) && !completer.isCompleted) completer.complete();
    });
    await completer.future.timeout(const Duration(seconds: 5));
    await sub.cancel();
    return states;
  }

  test('sem sessão começa em ReportLoading e não carrega nada', () async {
    final bloc = stack.menuBloc();
    expect(bloc.state, isA<TimesheetMenuReportLoadingState>());
    expect(bloc.state.list, isEmpty);
    expect(bloc.state.condominiumId, isNull);
    await Future<void>.delayed(Duration.zero);
    expect(stack.http.requests, isEmpty);
    await bloc.close();
  });

  test('com sessão carrega relatório do dia e depois os funcionários',
      () async {
    stack.happyPath();
    final bloc = stack.menuBloc(session: session);
    final states = await coletar(
        bloc, (s) => s is TimesheetMenuEmployeesLoadedState);

    expect(states.map((s) => s.runtimeType).toList(), [
      TimesheetMenuReportLoadingState,
      TimesheetMenuReportLoadedState,
      TimesheetMenuEmployeesLoadingState,
      TimesheetMenuEmployeesLoadedState,
    ]);
    final loaded = states.last as TimesheetMenuEmployeesLoadedState;
    expect(loaded.condominiumId, 'C1');
    expect(loaded.report!.totalAmount, 10);
    expect(loaded.list.map((e) => e.name), ['Maria Silva', 'Joao Souza']);
    expect(loaded.donePaging, false);

    final report = stack.http.requests.first;
    expect(report.url.path, '/timesheet/report/day/C1');
    expect(report.url.queryParameters['dob_from'], startsWith(isoDia(hoje).substring(0, 10)));
    expect(report.url.queryParameters['dob_to'], startsWith(isoDia(hoje).substring(0, 10)));
    expect(report.url.queryParameters.containsKey('type'), isFalse);
    expect(stack.http.requests.last.url.path, '/timesheet/employees/C1');
    await bloc.close();
  });

  test('sem funcionários emite WarningState', () async {
    stack.happyPath();
    stack.http.on('GET', '/timesheet/employees/C1', body: []);
    final bloc = stack.menuBloc(session: session);
    final states =
        await coletar(bloc, (s) => s is TimesheetMenuWarningState);
    final warning = states.last as TimesheetMenuWarningState;
    expect(warning.list, isEmpty);
    expect(warning.donePaging, true);
    expect(warning.report!.presentAmount, 6);
    await bloc.close();
  });

  test('falha no relatório emite ReportLoadFailed e ainda carrega funcionários',
      () async {
    stack.happyPath();
    stack.http.on('GET', '/timesheet/report/day/C1', status: 500);
    final bloc = stack.menuBloc(session: session);
    final states = await coletar(
        bloc, (s) => s is TimesheetMenuEmployeesLoadedState);
    expect(states.map((s) => s.runtimeType).toList(), [
      TimesheetMenuReportLoadingState,
      TimesheetMenuReportLoadFailedState,
      TimesheetMenuEmployeesLoadingState,
      TimesheetMenuEmployeesLoadedState,
    ]);
    final failed = states[1] as TimesheetMenuReportLoadFailedState;
    expect(failed.error, isA<UnknownFailure>());
    expect(failed.report, isNull);
    expect((states.last as TimesheetMenuEmployeesLoadedState).report, isNull);
    await bloc.close();
  });

  /// Defeito: `_mapLoadEmployees` monta `TimesheetMenuEmployeesLoadFailedState`
  /// com `state.query!` e `state.selectedMonth!`, mas o bloc nunca preenche
  /// `query` (e `selectedMonth` só vem dos argumentos da rota). Assim, qualquer
  /// falha ao listar funcionários explode com "Null check operator" em vez de
  /// emitir o estado de erro, e o bloc fica preso em EmployeesLoading.
  test('falha ao listar funcionários explode em vez de emitir erro (defeito)',
      () async {
    stack.happyPath();
    stack.http.on('GET', '/timesheet/employees/C1', status: 500);
    final errors = <Object>[];
    late TimesheetMenuBloc bloc;
    await runZonedGuarded(() async {
      bloc = stack.menuBloc(session: session);
      await coletar(bloc, (s) => s is TimesheetMenuEmployeesLoadingState);
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }, (e, _) => errors.add(e));

    expect(errors, isNotEmpty);
    expect(errors.first, isA<TypeError>());
    expect(bloc.state, isA<TimesheetMenuEmployeesLoadingState>());
    await bloc.close();
  });

  test('beginRefresh recarrega quando não está carregando', () async {
    stack.happyPath();
    final bloc = stack.menuBloc(session: session);
    await coletar(bloc, (s) => s is TimesheetMenuEmployeesLoadedState);
    expect(stack.http.requests.length, 2);

    bloc.beginRefresh();
    await coletar(bloc, (s) => s is TimesheetMenuEmployeesLoadedState);
    expect(stack.http.requests.length, 4);
    await bloc.close();
  });

  test('beginRefresh e beginRequest são ignorados durante o carregamento',
      () async {
    stack.happyPath();
    final bloc = stack.menuBloc(session: session);
    expect(bloc.state, isA<TimesheetMenuReportLoadingState>());
    bloc.beginRefresh();
    bloc.beginRequest();
    final states = await coletar(
        bloc, (s) => s is TimesheetMenuEmployeesLoadedState);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(states.whereType<TimesheetRequestLoadingState>(), isEmpty);
    expect(stack.http.requests.length, 2);
    await bloc.close();
  });

  test('beginRequest solicita o ponto digital com sucesso', () async {
    stack.happyPath();
    final bloc = stack.menuBloc(session: session);
    await coletar(bloc, (s) => s is TimesheetMenuEmployeesLoadedState);

    bloc.beginRequest();
    final states =
        await coletar(bloc, (s) => s is TimesheetRequestLoadedState);
    expect(states.map((s) => s.runtimeType).toList(),
        [TimesheetRequestLoadingState, TimesheetRequestLoadedState]);
    final loaded = states.last as TimesheetRequestLoadedState;
    expect(loaded.donePaging, false);
    expect(loaded.list.length, 2);
    expect(stack.http.requests.last.method, 'POST');
    expect(stack.http.requests.last.url.path, '/timesheet/request/C1');
    await bloc.close();
  });

  test('beginRequest com erro emite RequestLoadFailed', () async {
    stack.happyPath();
    stack.http.on('POST', '/timesheet/request/C1', status: 500);
    final bloc = stack.menuBloc(session: session);
    await coletar(bloc, (s) => s is TimesheetMenuEmployeesLoadedState);

    bloc.beginRequest();
    final states =
        await coletar(bloc, (s) => s is TimesheetRequestLoadFailedState);
    expect((states.last as TimesheetRequestLoadFailedState).error,
        isA<UnknownFailure>());
    await bloc.close();
  });

  test('eventos manuais usam o condomínio informado', () async {
    stack.happyPath(condominiumId: 'C9');
    final bloc = stack.menuBloc();
    bloc.add(const TimesheetMenuLoadEvent(condominiumId: 'C9'));
    await coletar(bloc, (s) => s is TimesheetMenuEmployeesLoadedState);
    expect(bloc.state.condominiumId, 'C9');
    bloc.add(const TimesheetRequestEvent(condominiumId: 'C9'));
    await coletar(bloc, (s) => s is TimesheetRequestLoadedState);
    expect(stack.http.requests.last.url.path, '/timesheet/request/C9');
    await bloc.close();
  });

  test('eventos e estados têm igualdade por props', () {
    expect(const TimesheetMenuLoadEvent(condominiumId: 'a'),
        const TimesheetMenuLoadEvent(condominiumId: 'a'));
    expect(const TimesheetMenuLoadEvent(condominiumId: 'a'),
        isNot(const TimesheetMenuLoadEvent(condominiumId: 'b')));
    expect(const TimesheetRequestEvent(condominiumId: 'a').props, ['a']);
    expect(const TimesheetMenuLoadEvent().props, [null]);

    final report = TimesheetReportDay(totalAmount: 1);
    final query = TimesheetFilter();
    final month = DateTime(2026, 8);
    final list = [Employee()..name = 'A'];
    final err = UnknownFailure('x');

    expect(TimesheetMenuReportLoadingState(null, null, null, null, null).list,
        isEmpty);
    expect(TimesheetMenuReportLoadingState(list, report, query, 'C1', month),
        TimesheetMenuReportLoadingState(list, report, query, 'C1', month));
    expect(
        TimesheetMenuReportLoadFailedState(list, report, query, 'C1', month, err)
            .props,
        [list, report, query, 'C1', month, err]);
    expect(TimesheetMenuReportLoadedState(list, report, query, 'C1', month).props,
        [list, report, query, 'C1', month]);
    expect(TimesheetMenuEmployeesLoadingState(list, report, query, 'C1', month),
        TimesheetMenuEmployeesLoadingState(list, report, query, 'C1', month));
    expect(
        TimesheetMenuEmployeesLoadFailedState(
                list, report, query, 'C1', month, err)
            .props
            .last,
        err);
    expect(
        TimesheetMenuEmployeesLoadedState(list, report, query, 'C1', month, true)
            .props
            .last,
        true);
    expect(
        TimesheetMenuWarningState(list, report, query, 'C1', month, true)
            .props
            .last,
        true);
    expect(TimesheetRequestLoadingState(list, report, query, 'C1', month).props,
        [list, report, query, 'C1', month]);
    expect(
        TimesheetRequestLoadFailedState(list, report, query, 'C1', month, err)
            .props
            .last,
        err);
    expect(
        TimesheetRequestLoadedState(list, report, query, 'C1', month, false)
            .props
            .last,
        false);
    expect(
        TimesheetRequestLoadedState(list, report, query, 'C1', month, false),
        isNot(TimesheetRequestLoadedState(list, report, query, 'C1', month, true)));
  });
}
