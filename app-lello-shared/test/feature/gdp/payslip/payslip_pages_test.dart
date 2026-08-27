import 'dart:async';

import 'package:essentials/essentials.dart' hide isNull, isNotNull, Address;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/bloc/employees/payslip_employees_bloc.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/bloc/employees/payslip_employees_state.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/bloc/selection/payslip_selection_bloc.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/bloc/selection/payslip_selection_state.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/page/payslip_employees_page.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/page/payslip_month_page.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/page/payslip_selection_page.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../../helpers/pump_app.dart';
import 'payslip_test_helpers.dart';

/// path_provider que nunca responde: o `renderPdf` fica aguardando e o
/// visualizador nativo (que não renderiza em teste) nunca é aberto.
class _HangingPathProvider extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  int calls = 0;
  @override
  Future<String?> getApplicationDocumentsPath() {
    calls++;
    return Completer<String>().future;
  }
}

void main() {
  late PayslipEnv env;
  late RecordingNavigatorObserver observer;
  final mes = DateTime(2026, 8);
  final monthFormat = DateFormat.yMMMM();

  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
  });

  setUp(() {
    env = PayslipEnv();
    observer = RecordingNavigatorObserver();
  });

  group('PayslipMonthPage', () {
    Future<PayslipEmployeesBloc> pumpMonth(WidgetTester tester,
        {bool withSession = true, bool settle = true}) async {
      final bloc = env.employeesBloc(withSession: withSession);
      bloc.state.selectedMonth = mes;
      final container = env.container()..register<PayslipEmployeesBloc>(bloc);
      await pumpPage(tester, PayslipMonthPage(appContainer: container),
          observer: observer, settle: settle);
      return bloc;
    }

    testWidgets('enquanto carrega mostra o indicador', (tester) async {
      final bloc = await pumpMonth(tester, withSession: false, settle: false);
      expect(bloc.state, isA<PayslipEmployeesLoadingState>());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('gdp_payslip_title'), findsOneWidget);
    });

    testWidgets('carregado mostra o mês atual e "próximo" navega com o mês',
        (tester) async {
      env.stubEmployees([employeeJson('E1')]);
      final bloc = await pumpMonth(tester);
      expect(bloc.state, isA<PayslipEmployeesLoadedState>());

      expect(find.text('gdp_payslip_selection_month'), findsOneWidget);
      expect(find.text(monthFormat.format(DateTime.now())), findsOneWidget);
      expect(find.text('Falha no carregamento'), findsNothing);

      await tester.tap(find.text('next'));
      await tester.pumpAndSettle();

      expect(observer.pushedNames.last, SharedApplicationRoute.gdpPayslipEmployees);
      final args = observer.pushed.last.settings.arguments as DateTime;
      expect(args.month, DateTime.now().month);
      expect(args.year, DateTime.now().year);
      expect(findRoute(SharedApplicationRoute.gdpPayslipEmployees), findsOneWidget);
    });

    testWidgets('golden', (tester) async {
      env.stubEmployees([employeeJson('E1')]);
      await pumpMonth(tester);
      await expectLater(find.byType(PayslipMonthPage),
          matchesGoldenFile('goldens/payslip_month_page.png'));
    });

    testWidgets('falha no carregamento mostra a mensagem e mantém o seletor',
        (tester) async {
      env.http.failAll();
      final bloc = await pumpMonth(tester);
      expect(bloc.state, isA<PayslipEmployeesLoadFailedState>());
      expect(find.text('Falha no carregamento'), findsOneWidget);
      expect(find.text('next'), findsOneWidget);
    });

    testWidgets('o seletor abre o month picker e aplica o mês escolhido',
        (tester) async {
      env.stubEmployees([employeeJson('E1')]);
      await pumpMonth(tester);
      final ano = DateTime.now().year;
      final janeiro = DateTime(ano, 1);

      await tester.tap(find.byType(OutlinedButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
      final loc = MaterialLocalizations.of(tester.element(find.byType(Dialog)));

      // cancelar não altera
      await tester.tap(find.widgetWithText(TextButton, loc.cancelButtonLabel));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
      expect(find.text(monthFormat.format(DateTime.now())), findsOneWidget);

      await tester.tap(find.byType(OutlinedButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text(DateFormat.MMM('pt_BR').format(janeiro)));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, loc.okButtonLabel));
      await tester.pumpAndSettle();

      expect(find.text(monthFormat.format(janeiro)), findsOneWidget);

      await tester.tap(find.text('next'));
      await tester.pumpAndSettle();
      expect(observer.pushed.last.settings.arguments, janeiro);
    });
  });

  group('PayslipEmployeesPage', () {
    Future<PayslipEmployeesBloc> pumpEmployees(WidgetTester tester) async {
      final bloc = env.employeesBloc();
      await settleBlocs(tester);
      final container = env.container()..register<PayslipEmployeesBloc>(bloc);
      await pumpPage(tester, PayslipEmployeesPage(appContainer: container),
          arguments: mes, observer: observer);
      return bloc;
    }

    testWidgets('lista os funcionários e navega para a seleção com o mês',
        (tester) async {
      env.stubEmployees([employeeJson('E1', name: 'Ana'), employeeJson('E2', name: 'Bia')]);
      final bloc = await pumpEmployees(tester);

      expect(bloc.state, isA<PayslipEmployeesLoadedState>());
      expect(bloc.state.selectedMonth, mes);
      expect(find.text('gdp_payslip_title'), findsOneWidget);
      expect(find.text('gdp_payslip_search_tooltip'), findsOneWidget);
      expect(find.text('Ana'), findsOneWidget);
      expect(find.text('Porteiro'), findsNWidgets(2));

      await tester.tap(find.text('Bia'));
      await tester.pumpAndSettle();

      expect(observer.pushedNames.last, SharedApplicationRoute.gdpPayslipSelection);
      final args = observer.pushed.last.settings.arguments as Map;
      expect((args['entity'] as Employee).id, 'E2');
      expect(args['selectedMonth'], mes);
    });

    testWidgets('golden', (tester) async {
      env.stubEmployees([employeeJson('E1', name: 'Ana Souza')]);
      await pumpEmployees(tester);
      await expectLater(find.byType(PayslipEmployeesPage),
          matchesGoldenFile('goldens/payslip_employees_page.png'));
    });

    testWidgets('sem funcionários mostra a mensagem de vazio', (tester) async {
      env.stubEmployees([]);
      await pumpEmployees(tester);
      expect(find.text('gdp_payslip_error_no_employee'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('digitar busca por nome e mostra o indicador durante a busca',
        (tester) async {
      env.stubEmployees([employeeJson('E1', name: 'Ana'), employeeJson('E2', name: 'Bia')]);
      final bloc = await pumpEmployees(tester);
      env.http.requests.clear();
      env.stubEmployees([employeeJson('E1', name: 'Ana')]);

      await tester.enterText(find.byType(TextField), 'An');
      await tester.pumpAndSettle();

      expect(env.http.requests.single.url.queryParameters['name'], 'An');
      expect(bloc.state.query, 'An');
      expect(find.text('Bia'), findsNothing);
      expect(find.text('Ana'), findsOneWidget);

      // ignore: invalid_use_of_visible_for_testing_member
      bloc.emit(PayslipEmployeesSearchingState(bloc.state.data, 'An', 'C1', mes));
      await tester.pump();
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Ana'), findsOneWidget);
      // ignore: invalid_use_of_visible_for_testing_member
      bloc.emit(PayslipEmployeesLoadedState(bloc.state.data, 'An', 'C1', mes, false));
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('rolar até o fim carrega a próxima página com o indicador',
        (tester) async {
      env.stubEmployees(List.generate(12, (i) => employeeJson('E$i', name: 'Func $i')));
      final bloc = await pumpEmployees(tester);
      env.http.requests.clear();
      env.stubEmployees([employeeJson('E99', name: 'Último')]);

      await tester.drag(find.byType(ListView), const Offset(0, -3000));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(env.http.requests.first.url.queryParameters['last_employee_id'], 'E11');
      expect(bloc.state.data.length, 12 + env.http.requests.length);

      // ignore: invalid_use_of_visible_for_testing_member
      bloc.emit(PayslipEmployeesPagingState(bloc.state.data, null, 'C1', mes));
      await tester.pump();
      await tester.pump();
      await tester.drag(find.byType(ListView), const Offset(0, -5000));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // ignore: invalid_use_of_visible_for_testing_member
      bloc.emit(PayslipEmployeesLoadedState(bloc.state.data, null, 'C1', mes, true));
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('puxar para atualizar recarrega a lista', (tester) async {
      env.stubEmployees([employeeJson('E1', name: 'Ana')]);
      final bloc = await pumpEmployees(tester);
      env.http.requests.clear();
      env.stubEmployees([employeeJson('E1', name: 'Ana'), employeeJson('E2', name: 'Bia')]);

      final indicator =
          tester.state<RefreshIndicatorState>(find.byType(RefreshIndicator));
      unawaited(indicator.show());
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(env.http.requests, hasLength(1));
      expect(bloc.state, isA<PayslipEmployeesLoadedState>());
      expect(find.text('Bia'), findsOneWidget);
    });

    /// Defeito (não reproduzível sem derrubar o teste): o listener chama
    /// `refreshKey.currentState!.show()` a cada estado de carregamento, mas
    /// durante o carregamento o builder mostra só um
    /// `CircularProgressIndicator` (sem `RefreshIndicator`); abrir a página
    /// com o bloc ainda carregando estoura "Null check operator used on a
    /// null value" no primeiro estado emitido. Por isso os testes acima
    /// montam a página com o bloc já carregado.
  });

  group('PayslipSelectionPage', () {
    late _HangingPathProvider pathProvider;

    setUp(() {
      pathProvider = _HangingPathProvider();
      PathProviderPlatform.instance = pathProvider;
    });

    Future<PayslipSelectionBloc> pumpSelection(WidgetTester tester,
        {bool withSession = true, Object? arguments, bool settle = true}) async {
      final bloc = env.selectionBloc(withSession: withSession);
      final container = env.container()..register<PayslipSelectionBloc>(bloc);
      await pumpPage(tester, PayslipSelectionPage(appContainer: container),
          arguments: arguments ?? {'entity': employee(id: 'M1'), 'selectedMonth': mes},
          observer: observer, settle: settle);
      return bloc;
    }

    testWidgets('lista os holerites do mês e tocar baixa o arquivo',
        (tester) async {
      env.stubPayslips('M1', [
        payslipJson(name: 'ago.pdf', description: 'Agosto', date: '2026-08-05T00:00:00.000'),
        payslipJson(name: 'jul.pdf', description: 'Julho', date: '2026-07-05T00:00:00.000'),
      ]);
      env.stubPayslipFile('ago.pdf', 'M1');
      final bloc = await pumpSelection(tester);

      expect(bloc.state, isA<PayslipLoadedState>());
      expect(find.text('Agosto'), findsOneWidget);
      expect(find.text('Julho'), findsNothing);
      expect(find.text(DateFormat.yMd().format(DateTime(2026, 8, 5))), findsOneWidget);
      await expectLater(find.byType(PayslipSelectionPage),
          matchesGoldenFile('goldens/payslip_selection_page.png'));

      await tester.tap(find.text('Agosto'));
      await tester.pumpAndSettle();

      expect(env.paths.last, '/digitalRepository/documents/ago.pdf/M1');
      expect(bloc.state, isA<PayslipFileDownloadedState>());
      expect(bloc.state.payslipFile.data, pdfBase64);
      // o pdf começou a ser gravado (path_provider chamado) e a lista some
      expect(pathProvider.calls, greaterThanOrEqualTo(1));
      expect(find.byType(ListTile), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('sem holerites no mês mostra a mensagem', (tester) async {
      env.stubPayslips('M1', [payslipJson(date: '2025-01-01T00:00:00.000')]);
      await pumpSelection(tester);
      expect(find.text('gdp_payslip_error_no_file'), findsOneWidget);
    });

    testWidgets('falha ao carregar mostra o erro', (tester) async {
      env.http.failAll();
      final bloc = await pumpSelection(tester);
      expect(bloc.state, isA<PayslipLoadFailedState>());
      expect(find.text('error_unknown'), findsOneWidget);
    });

    testWidgets('enquanto carrega mostra o indicador', (tester) async {
      final bloc = await pumpSelection(tester, withSession: false, settle: false);
      expect(bloc.state, isA<PayslipLoadingState>());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
