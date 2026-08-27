import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_filter.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_report_day.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_type_enum.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_menu/timesheet_menu_bloc.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_menu/timesheet_menu_state.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/page/timesheet_menu.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../../helpers/pump_app.dart';
import '../../../helpers/test_container.dart';
import 'timesheet_test_helpers.dart';

void main() {
  late TimesheetStack stack;
  late TestSharedContainer container;
  late RecordingNavigatorObserver observer;
  final session = FakeSharedSession();

  setUp(() {
    stack = TimesheetStack();
    observer = RecordingNavigatorObserver();
    container = TestSharedContainer()
      ..registerLazy<TimesheetMenuBloc>(() => stack.menuBloc(session: session));
  });

  tearDown(() => container.reset());

  TimesheetMenuBloc bloc() => container.resolve<TimesheetMenuBloc>();

  Finder rich(String text) => find.byWidgetPredicate(
      (w) => w is RichText && w.text.toPlainText() == text);

  TimesheetFilter argsDoUltimoPush() =>
      observer.pushed.last.settings.arguments as TimesheetFilter;

  /// Largura em que os cards do resumo cabem sem estourar (ver defeito abaixo).
  const superficie = Size(480, 900);

  Future<void> voltar(WidgetTester tester, String rota) async {
    Navigator.of(tester.element(findRoute(rota))).pop();
    await tester.pumpAndSettle();
  }

  testWidgets('mostra o resumo do dia, as opções e o golden', (tester) async {
    stack.happyPath();
    await pumpPage(tester, TimesheetMenuPage(appContainer: container),
        observer: observer,
        arguments: DateTime(hoje.year, hoje.month),
        surface: superficie);

    expect(find.text('gdp_timesheet_appBar'), findsOneWidget);
    expect(find.text('gdp_timesheet_tab_overview'), findsOneWidget);
    expect(find.text('gdp_timesheet_label_today'), findsOneWidget);
    expect(rich('6/10'), findsOneWidget); // presentes
    expect(rich('1/10'), findsNWidgets(4)); // folga, férias, sem marcação, turno
    expect(rich('0/10'), findsOneWidget); // atestado
    expect(find.text('gdp_timesheet_grid_working'), findsOneWidget);
    expect(find.text('gdp_timesheet_grid_day_off'), findsOneWidget);
    expect(find.text('gdp_timesheet_grid_vacation'), findsOneWidget);
    expect(find.text('gdp_timesheet_grid_attestation'), findsOneWidget);
    expect(find.text('gdp_timesheet_grid_unmarked'), findsOneWidget);
    expect(find.text('gdp_timesheet_grid_shift_not_started'), findsOneWidget);
    expect(find.text('gdp_timesheet_menu_option_event'), findsOneWidget);
    expect(find.text('gdp_timesheet_menu_option_sign'), findsOneWidget);
    expect(bloc().state, isA<TimesheetMenuEmployeesLoadedState>());
    expect(bloc().state.selectedMonth, DateTime(hoje.year, hoje.month));
    expect(TimesheetMenuPageArgs(bloc()).timesheetMenuBloc, same(bloc()));
    expect(stack.http.requests.map((r) => r.url.path),
        contains('/timesheet/report/day/C1'));

    await expectLater(find.byType(MaterialApp),
        matchesGoldenFile('goldens/timesheet_menu_overview.png'));
  });

  testWidgets('cada card do resumo abre a lista com o filtro do dia',
      (tester) async {
    stack.happyPath();
    await pumpPage(tester, TimesheetMenuPage(appContainer: container),
        observer: observer, surface: superficie);

    final casos = {
      'gdp_timesheet_grid_working': TimesheetTypeEnum.present,
      'gdp_timesheet_grid_day_off': TimesheetTypeEnum.dayOff,
      'gdp_timesheet_grid_vacation': TimesheetTypeEnum.vacation,
      'gdp_timesheet_grid_attestation': TimesheetTypeEnum.attestation,
      'gdp_timesheet_grid_unmarked': TimesheetTypeEnum.unmarked,
      'gdp_timesheet_grid_shift_not_started': TimesheetTypeEnum.shiftNotStarted,
    };
    for (final entry in casos.entries) {
      await tester.tap(find.text(entry.key));
      await tester.pumpAndSettle();
      expect(observer.pushedNames.last, SharedApplicationRoute.gdpTimesheetList);
      final filtro = argsDoUltimoPush();
      expect(filtro.type, entry.value);
      expect(filtro.dobFrom, hoje);
      expect(filtro.dobTo, hoje);
      await voltar(tester, SharedApplicationRoute.gdpTimesheetList);
    }
  });

  testWidgets('ocorrências abre a lista dos últimos 90 dias e assinar abre as assinaturas',
      (tester) async {
    stack.happyPath();
    await pumpPage(tester, TimesheetMenuPage(appContainer: container),
        observer: observer, surface: superficie);

    await tester.tap(find.text('gdp_timesheet_menu_option_event'));
    await tester.pumpAndSettle();
    expect(observer.pushedNames.last, SharedApplicationRoute.gdpTimesheetList);
    var filtro = argsDoUltimoPush();
    expect(filtro.type, TimesheetTypeEnum.events);
    expect(filtro.dobFrom, hoje.subtract(const Duration(days: 90)));
    expect(filtro.dobTo, hoje);
    await voltar(tester, SharedApplicationRoute.gdpTimesheetList);

    await tester.tap(find.text('gdp_timesheet_menu_option_sign'));
    await tester.pumpAndSettle();
    expect(observer.pushedNames.last, SharedApplicationRoute.gdpTimesheetSign);
    filtro = argsDoUltimoPush();
    expect(filtro.type, TimesheetTypeEnum.events);
    expect(filtro.dobFrom, DateTime(hoje.year, hoje.month, 1));
    expect(filtro.dobTo, hoje);
  });

  testWidgets('aba de funcionários lista, abre o espelho do funcionário e tem golden',
      (tester) async {
    stack.happyPath();
    await pumpPage(tester, TimesheetMenuPage(appContainer: container),
        observer: observer, surface: superficie);

    await tester.tap(find.text('gdp_timesheet_tab_employees'));
    await tester.pumpAndSettle();
    expect(find.text('Maria Silva'), findsOneWidget);
    expect(find.text('PORTEIRO'), findsOneWidget);
    expect(find.text('Joao Souza'), findsOneWidget);

    await expectLater(find.byType(MaterialApp),
        matchesGoldenFile('goldens/timesheet_menu_employees.png'));

    await tester.tap(find.text('Joao Souza'));
    await tester.pumpAndSettle();
    expect(observer.pushedNames.last, SharedApplicationRoute.gdpTimesheetList);
    final filtro = argsDoUltimoPush();
    expect(filtro.type, TimesheetTypeEnum.employee);
    expect(filtro.name, 'Joao Souza');
    expect(filtro.dobFrom, hoje);
  });

  testWidgets('sem funcionários vai para a tela de aviso', (tester) async {
    stack.happyPath();
    stack.http.on('GET', '/timesheet/employees/C1', body: []);
    await pumpPage(tester, TimesheetMenuPage(appContainer: container),
        observer: observer, surface: superficie);

    expect(bloc().state, isA<TimesheetMenuWarningState>());
    expect(findRoute(SharedApplicationRoute.gdpTimesheetWarning), findsOneWidget);
  });

  testWidgets('puxar para atualizar recarrega e a rolagem dos funcionários dispara o listener',
      (tester) async {
    stack.happyPath();
    stack.http.on('GET', '/timesheet/employees/C1', body: [
      for (var i = 0; i < 30; i++) employeeJson(id: 'E$i', name: 'Func $i'),
    ]);
    await pumpPage(tester, TimesheetMenuPage(appContainer: container),
        observer: observer, surface: superficie);
    final antes = stack.http.requests.length;

    await tester.fling(find.byType(GridView), const Offset(0, 300), 1000);
    await tester.pumpAndSettle();
    expect(stack.http.requests.length, greaterThan(antes));

    await tester.tap(find.text('gdp_timesheet_tab_employees'));
    await tester.pumpAndSettle();
    expect(find.text('Func 0'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();
    expect(find.text('Func 0'), findsNothing);

    await tester.drag(find.byType(ListView), const Offset(0, 600));
    await tester.pumpAndSettle();
    expect(find.text('Func 0'), findsOneWidget);
    final depois = stack.http.requests.length;
    await tester.fling(find.byType(ListView), const Offset(0, 300), 1000);
    await tester.pumpAndSettle();
    expect(stack.http.requests.length, greaterThan(depois));
  });

  testWidgets('estados de erro mostram a mensagem no resumo e na aba de funcionários',
      (tester) async {
    stack.happyPath();
    await pumpPage(tester, TimesheetMenuPage(appContainer: container),
        observer: observer, surface: superficie);
    final b = bloc();

    // ignore: invalid_use_of_visible_for_testing_member
    b.emit(TimesheetMenuReportLoadFailedState(
        b.state.list, null, null, 'C1', null, UnknownFailure('x')));
    await tester.pumpAndSettle();
    expect(find.text('gdp_timesheet_error'), findsOneWidget);
    expect(rich('6/10'), findsNothing);

    // ignore: invalid_use_of_visible_for_testing_member
    b.emit(TimesheetMenuEmployeesLoadFailedState(
        b.state.list,
        TimesheetReportDay(),
        TimesheetFilter(),
        'C1',
        hoje,
        UnknownFailure('x')));
    await tester.pumpAndSettle();
    expect(find.text('gdp_timesheet_error'), findsOneWidget);
    await tester.tap(find.text('gdp_timesheet_tab_employees'));
    await tester.pumpAndSettle();
    expect(find.text('gdp_timesheet_error'), findsWidgets);
    expect(find.text('Maria Silva'), findsNothing);
  });

  testWidgets('sem funcionários carregados a aba mostra vazio', (tester) async {
    stack.happyPath();
    await pumpPage(tester, TimesheetMenuPage(appContainer: container),
        observer: observer, surface: superficie);
    final b = bloc();
    // ignore: invalid_use_of_visible_for_testing_member
    b.emit(TimesheetMenuEmployeesLoadedState(
        <Employee>[], b.state.report, null, 'C1', null, true));
    await tester.pumpAndSettle();
    await tester.tap(find.text('gdp_timesheet_tab_employees'));
    await tester.pumpAndSettle();
    expect(find.text('gdp_timesheet_empty'), findsOneWidget);
  });

  /// Defeito: ao concluir a solicitação do ponto digital o menu navega para a
  /// tela de "espelhos assinados" (`gdpTimesheetSignSuccess`) e não para a de
  /// "email enviado" (`gdpTimesheetRequestSuccess`).
  testWidgets('solicitação concluída navega para o sucesso de assinatura (defeito)',
      (tester) async {
    stack.happyPath();
    await pumpPage(tester, TimesheetMenuPage(appContainer: container),
        observer: observer, surface: superficie);
    bloc().beginRequest();
    await tester.pumpAndSettle();
    expect(bloc().state, isA<TimesheetRequestLoadedState>());
    expect(findRoute(SharedApplicationRoute.gdpTimesheetSignSuccess),
        findsOneWidget);
  });

  /// Defeito: em telas de 400px de largura o card do resumo
  /// (`_retangularButton`, `childAspectRatio: 1.4`) estoura ~6px na vertical.
  testWidgets('cards do resumo estouram em telas estreitas (defeito)',
      (tester) async {
    stack.happyPath();
    await pumpPage(tester, TimesheetMenuPage(appContainer: container),
        observer: observer);
    final erro = tester.takeException();
    expect(erro, isA<FlutterError>());
    expect(erro.toString(), contains('overflowed'));
  });
}
