import 'package:essentials/essentials.dart' hide isNull, isNotNull, Address;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/entity/employee_report_filter.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/entity/employee_report_type.dart';
import 'package:shared_features/feature/gdp/quick_fix/presentation/bloc/quick_fix/quick_fix_bloc.dart';
import 'package:shared_features/feature/gdp/quick_fix/presentation/bloc/quick_fix/quick_fix_state.dart';
import 'package:shared_features/feature/gdp/quick_fix/presentation/bloc/report/quick_fix_report_bloc.dart';
import 'package:shared_features/feature/gdp/quick_fix/presentation/bloc/report/quick_fix_report_state.dart';
import 'package:shared_features/feature/gdp/quick_fix/presentation/page/quick_fix_page.dart';
import 'package:shared_features/feature/gdp/quick_fix/presentation/page/quick_fix_report_page.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../../helpers/firebase_mocks.dart';
import '../../../helpers/pump_app.dart';
import 'quick_fix_test_helpers.dart';

void main() {
  late QuickFixEnv env;
  late RecordingNavigatorObserver observer;
  final currency = NumberFormat.currency(symbol: 'R\$');
  final dateFormat = DateFormat.yMd();

  setUpAll(() async {
    await setUpFakeFirebase();
  });

  setUp(() {
    env = QuickFixEnv();
    observer = RecordingNavigatorObserver();
  });

  group('QuickFixPage', () {
    Future<QuickFixBloc> pumpQuickFix(WidgetTester tester,
        {bool withSession = true}) async {
      final bloc = env.quickFixBloc(withSession: withSession);
      final container = env.container()..register<QuickFixBloc>(bloc);
      await pumpPage(tester, QuickFixPage(appContainer: container), observer: observer);
      return bloc;
    }

    Finder dropdown(int index) =>
        find.byWidgetPredicate((w) => w is DropdownButtonFormField).at(index);

    testWidgets('escolher funcionário e tipo gera o relatório com o filtro',
        (tester) async {
      env.stubEmployees([employeeJson('E1', name: 'Ana'), employeeJson('E2', name: 'Bia')]);
      final bloc = await pumpQuickFix(tester);

      expect(bloc.state, isA<QuickFixLoadedState>());
      /// Corrigido: os itens do seletor de funcionário não têm mais largura
      /// fixa (`MediaQuery.width - 80`), então a lista é montada sem
      /// "RenderFlex overflowed".
      expect(tester.takeException(), isNull);
      expect(find.text('gdp_quick_fix_title'), findsOneWidget);
      expect(find.text('gdp_quick_fix_description'), findsOneWidget);
      expect(find.text('gdp_quick_fix_employee'), findsOneWidget);
      expect(find.text('gdp_quick_fix_preview'), findsOneWidget);
      expect(find.text('gdp_quick_fix_select'), findsNWidgets(2));
      await expectLater(find.byType(QuickFixPage),
          matchesGoldenFile('goldens/quick_fix_page.png'));

      await tester.tap(dropdown(0));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bia').last);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(dropdown(1));
      await tester.pumpAndSettle();
      expect(find.text('gdp_quick_fix_report_type_vacation'), findsOneWidget);
      await tester.tap(find.text('gdp_quick_fix_report_type_termination').last);
      await tester.pumpAndSettle();
      expect(find.text('gdp_quick_fix_select'), findsNothing);
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('gdp_quick_fix_generate_report'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      expect(observer.pushedNames.last, SharedApplicationRoute.gdpQuickFixReport);
      final args = observer.pushed.last.settings.arguments as EmployeeReportFilter;
      expect(args.employee?.id, 'E2');
      expect(args.reportType, EmployeeReportType.termination);
      expect(findRoute(SharedApplicationRoute.gdpQuickFixReport), findsOneWidget);
    });

    testWidgets('gerar sem escolher navega com o filtro vazio', (tester) async {
      env.stubEmployees([employeeJson('E1', name: 'Ana')]);
      await pumpQuickFix(tester);
      /// Corrigido: os itens do seletor de funcionário não têm mais largura
      /// fixa (`MediaQuery.width - 80`), então a lista é montada sem
      /// "RenderFlex overflowed".
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('gdp_quick_fix_generate_report'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final args = observer.pushed.last.settings.arguments as EmployeeReportFilter;
      expect(args.employee, isNull);
      expect(args.reportType, isNull);
    });

    testWidgets('enquanto carrega os seletores ficam desabilitados', (tester) async {
      final bloc = await pumpQuickFix(tester, withSession: false);
      expect(bloc.state, isA<QuickFixLoadingState>());
      expect(find.text('gdp_quick_fix_description'), findsOneWidget);
      await tester.tap(dropdown(0));
      await tester.pumpAndSettle();
      expect(find.byType(ListTile), findsNWidgets(2));
      expect(find.text('gdp_quick_fix_report_type_vacation'), findsNothing);
    });

    testWidgets('falha mostra a mensagem de erro', (tester) async {
      env.http.failAll();
      final bloc = await pumpQuickFix(tester);
      expect(bloc.state, isA<QuickFixLoadFailedState>());
      expect(find.text('error_unknown'), findsOneWidget);
      expect(find.byWidgetPredicate((w) => w is DropdownButtonFormField), findsNothing);
    });
  });

  group('QuickFixReportPage', () {
    Future<QuickFixReportBloc> pumpReport(WidgetTester tester,
        {Object? arguments, bool settle = true}) async {
      final bloc = env.reportBloc();
      final container = env.container()..register<QuickFixReportBloc>(bloc);
      await pumpPage(tester, QuickFixReportPage(appContainer: container),
          arguments: arguments, settle: settle, surface: const Size(400, 1400));
      return bloc;
    }

    EmployeeReportFilter filtro(EmployeeReportType type) => EmployeeReportFilter(
        employee: employee(full: true, name: 'Carlos'), reportType: type);

    testWidgets('relatório de férias mostra cabeçalho, funcionário e itens',
        (tester) async {
      env.stubReport('E1', reportJson());
      final bloc = await pumpReport(tester, arguments: filtro(EmployeeReportType.vacation));

      expect(bloc.state, isA<QuickFixReportLoadedState>());
      expect(find.text('gdp_quick_fix_report_title'), findsOneWidget);
      expect(find.text('gdp_quick_fix_report_preview_vacation'), findsOneWidget);
      expect(find.text('gdp_quick_fix_report_condominium_reference'), findsOneWidget);
      expect(find.text('Condomínio X'), findsOneWidget);
      expect(find.text('gdp_quick_fix_report_vacation_type'), findsOneWidget);
      // funcionário do relatório tem prioridade sobre o do filtro
      expect(find.text('Ana'), findsOneWidget);
      expect(find.text('Carlos'), findsNothing);
      expect(find.text('Porteiro'), findsOneWidget);
      expect(find.text(dateFormat.format(DateTime(2020, 3, 4))), findsOneWidget);
      expect(find.text(currency.format(2500.5)), findsOneWidget);
      expect(find.text('Férias'), findsOneWidget);
      expect(find.text(currency.format(1234.5)), findsOneWidget);
      expect(find.text('1/3 de férias'), findsOneWidget);
      expect(find.text(currency.format(411.5)), findsOneWidget);
      expect(find.text('gdp_quick_fix_report_employee_termination'), findsNothing);
      expect(find.text('gdp_quick_fix_report_stability_section_title'), findsNothing);
      expect(find.text('gdp_quick_fix_report_disclaimer_vacation'), findsOneWidget);
      expect(find.byType(Divider), findsNWidgets(2));

      await expectLater(find.byType(QuickFixReportPage),
          matchesGoldenFile('goldens/quick_fix_report_page_vacation.png'));
    });

    testWidgets('relatório de rescisão mostra desligamento e estabilidade',
        (tester) async {
      env.stubReport('E1', reportJson(type: 'termination', includeEmployee: false));
      await pumpReport(tester, arguments: filtro(EmployeeReportType.termination));

      expect(find.text('gdp_quick_fix_report_preview_termination'), findsOneWidget);
      expect(find.text('gdp_quick_fix_report_termination_type'), findsOneWidget);
      expect(find.text('gdp_quick_fix_report_termination_type_subtitle'), findsOneWidget);
      // sem funcionário no relatório usa o do filtro
      expect(find.text('Carlos'), findsOneWidget);
      expect(find.text('gdp_quick_fix_report_employee_termination'), findsOneWidget);
      expect(find.text(dateFormat.format(DateTime.now())), findsOneWidget);
      expect(find.text('gdp_quick_fix_report_stability_section_title'), findsOneWidget);
      expect(find.text('Gestante'), findsOneWidget);
      expect(find.text(dateFormat.format(DateTime(2026, 1, 10))), findsOneWidget);
      expect(find.text(dateFormat.format(DateTime(2026, 6, 10))), findsOneWidget);
      expect(find.text('gdp_quick_fix_report_disclaimer_termination'), findsOneWidget);

      await expectLater(find.byType(QuickFixReportPage),
          matchesGoldenFile('goldens/quick_fix_report_page_termination.png'));
    });

    testWidgets('sem itens mostra a mensagem de erro e estabilidade vazia com "-"',
        (tester) async {
      env.stubReport(
          'E1',
          reportJson(
              type: 'termination',
              items: [],
              stabilityDescription: null,
              stabilityStart: null,
              stabilityEnd: null));
      await pumpReport(tester, arguments: filtro(EmployeeReportType.termination));

      expect(find.text('gdp_quick_fix_report_error'), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);
      expect(find.text('-'), findsNWidgets(3));
    });

    testWidgets('falha na api mostra o erro', (tester) async {
      env.http.failAll();
      final bloc = await pumpReport(tester, arguments: filtro(EmployeeReportType.vacation));
      expect(bloc.state, isA<QuickFixReportLoadFailedState>());
      expect(find.text('error_unknown'), findsOneWidget);
    });

    testWidgets('sem argumentos não carrega e mostra o erro de filtro',
        (tester) async {
      final bloc = await pumpReport(tester);
      expect(bloc.state, isA<QuickFixReportLoadFailedState>());
      expect(find.text('error_unknown'), findsOneWidget);
      expect(env.http.requests, isEmpty);
    });

    testWidgets('enquanto carrega mostra o indicador', (tester) async {
      env.stubReport('E1', reportJson());
      final bloc = await pumpReport(tester, arguments: filtro(EmployeeReportType.vacation));
      // ignore: invalid_use_of_visible_for_testing_member
      bloc.emit(QuickFixReportLoadingState(bloc.state.data, condominium()));
      await tester.pump();
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // ignore: invalid_use_of_visible_for_testing_member
      bloc.emit(QuickFixReportLoadedState(bloc.state.data!, condominium()));
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
