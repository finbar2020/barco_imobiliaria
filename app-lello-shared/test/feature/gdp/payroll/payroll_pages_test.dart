import 'package:essentials/essentials.dart' hide isNull, isNotNull, Address;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_features/feature/gdp/payroll/domain/entity/payroll.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/bloc/payroll/payroll_bloc.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/bloc/payroll/payroll_state.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/bloc/payroll_entry/payroll_entry_bloc.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/bloc/payroll_entry/payroll_entry_state.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/page/payroll_detail_page.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/page/payroll_entry_list_page.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/page/payroll_page.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/widget/payroll_entry_list_item.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../../helpers/pump_app.dart';
import 'payroll_test_helpers.dart';

void main() {
  late PayrollEnv env;
  late RecordingNavigatorObserver observer;
  final monthFormat = DateFormat.yMMMM();
  final currency = NumberFormat.currency(symbol: 'R\$');

  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
  });

  setUp(() {
    env = PayrollEnv();
    observer = RecordingNavigatorObserver();
  });

  group('PayrollPage', () {
    /// Bloc como factory: nasce no `initState` e a página recebe o
    /// `PayrollListLoadedState` no listener (que define o mês selecionado).
    Future<PayrollBloc Function()> pumpPayroll(WidgetTester tester,
        {bool settle = true}) async {
      PayrollBloc? bloc;
      final container = env.container()
        ..registerFactory<PayrollBloc>(() => bloc = env.payrollBloc());
      await pumpPage(tester, PayrollPage(appContainer: container),
          observer: observer, settle: settle);
      return () => bloc!;
    }

    testWidgets('mostra o último período e buscar abre o detalhe da folha',
        (tester) async {
      env.stubPayrolls([payrollJson(period: '2026-07-01T00:00:00.000'), payrollJson()]);
      env.stubPayroll('2026-08', payrollJson(type: 'Adiantamento'));
      final bloc = await pumpPayroll(tester);

      expect(bloc().state, isA<PayrollListLoadedState>());
      expect(find.text('gdp_payroll'), findsOneWidget);
      expect(find.text('payroll_month'), findsOneWidget);
      expect(find.text(monthFormat.format(DateTime(2026, 8))), findsOneWidget);
      expect(find.text('payroll_load_failed'), findsNothing);
      await expectLater(find.byType(PayrollPage),
          matchesGoldenFile('goldens/payroll_page.png'));

      await tester.tap(find.text('search'));
      await tester.pumpAndSettle();

      expect(env.paths.last, '$payrollsPath/2026-08');
      expect(bloc().state, isA<PayrollLoadedState>());
      expect(observer.pushedNames.last, SharedApplicationRoute.gdppayrollDetail);
      expect((observer.pushed.last.settings.arguments as Payroll).type, 'Adiantamento');
      expect(findRoute(SharedApplicationRoute.gdppayrollDetail), findsOneWidget);
    });

    testWidgets('falha ao buscar a folha mostra a mensagem de erro', (tester) async {
      env.stubPayrolls([payrollJson()]);
      final bloc = await pumpPayroll(tester);
      env.http.failAll();

      await tester.tap(find.text('search'));
      await tester.pumpAndSettle();

      expect(bloc().state, isA<PayrollLoadFailedState>());
      expect(find.text('payroll_load_failed'), findsOneWidget);
      expect(observer.pushedNames, isNot(contains(SharedApplicationRoute.gdppayrollDetail)));
    });

    /// Defeito: quando a lista de folhas falha, `selectedMonth` fica nulo, o
    /// seletor mostra texto vazio e tocar em "buscar" estoura
    /// `selectedMonth!` (Null check operator).
    testWidgets('falha na lista deixa o mês vazio e buscar estoura', (tester) async {
      env.http.failAll();
      final bloc = await pumpPayroll(tester);
      expect(bloc().state, isA<PayrollLoadFailedState>());
      expect(find.text('payroll_load_failed'), findsOneWidget);
      expect(find.text(''), findsOneWidget);

      await tester.tap(find.text('search'));
      await tester.pump();

      expect(tester.takeException(), isA<TypeError>());
    });

    testWidgets('enquanto carrega mostra o indicador', (tester) async {
      env.stubPayrolls([payrollJson()]);
      final bloc = await pumpPayroll(tester);
      // ignore: invalid_use_of_visible_for_testing_member
      bloc().emit(const PayrollLoadingState([], null, 'C1'));
      await tester.pump();
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // ignore: invalid_use_of_visible_for_testing_member
      bloc().emit(PayrollListLoadedState(bloc().state.data, 'C1'));
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('o month picker só permite meses entre a primeira e a última folha',
        (tester) async {
      env.stubPayrolls([payrollJson(period: '2026-07-01T00:00:00.000'), payrollJson()]);
      await pumpPayroll(tester);
      final julho = DateTime(2026, 7);
      final junho = DateTime(2026, 6);
      final mmm = DateFormat.MMM('pt_BR');

      await tester.tap(find.byType(OutlinedButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
      final loc = MaterialLocalizations.of(tester.element(find.byType(Dialog)));

      // junho está fora do intervalo: botão desabilitado
      final botaoJunho = tester.widget<TextButton>(
          find.widgetWithText(TextButton, mmm.format(junho)));
      expect(botaoJunho.onPressed, isNull);
      final botaoJulho = tester.widget<TextButton>(
          find.widgetWithText(TextButton, mmm.format(julho)));
      expect(botaoJulho.onPressed, isNotNull);

      await tester.tap(find.widgetWithText(TextButton, loc.cancelButtonLabel));
      await tester.pumpAndSettle();
      expect(find.text(monthFormat.format(DateTime(2026, 8))), findsOneWidget);

      await tester.tap(find.byType(OutlinedButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text(mmm.format(julho)));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, loc.okButtonLabel));
      await tester.pumpAndSettle();

      expect(find.text(monthFormat.format(julho)), findsOneWidget);
      env.stubPayroll('2026-07', payrollJson(type: 'Julho'));
      await tester.tap(find.text('search'));
      await tester.pumpAndSettle();
      expect(env.paths.last, '$payrollsPath/2026-07');
    });
  });

  group('PayrollDetailPage', () {
    testWidgets('mostra o resumo e "detalhes" abre os lançamentos', (tester) async {
      final p = payroll();
      await pumpPage(tester, PayrollDetailPage(), arguments: p, observer: observer);

      expect(find.text('gdp_payroll'), findsOneWidget);
      expect(find.text('payroll_information'), findsOneWidget);
      expect(find.text(monthFormat.format(DateTime(2026, 8))), findsOneWidget);
      expect(find.text('payroll_type'), findsOneWidget);
      expect(find.text('Mensal'), findsOneWidget);
      expect(find.text('payroll_summary'), findsOneWidget);
      expect(find.text(currency.format(10000.5)), findsOneWidget);
      expect(find.text(currency.format(1500.25)), findsOneWidget);
      expect(find.text(currency.format(8500.25)), findsOneWidget);
      await expectLater(find.byType(PayrollDetailPage),
          matchesGoldenFile('goldens/payroll_detail_page.png'));

      await tester.tap(find.text('payroll_details'));
      await tester.pumpAndSettle();

      expect(observer.pushedNames.last, SharedApplicationRoute.gdppayrollEntry);
      expect(observer.pushed.last.settings.arguments, same(p));
      expect(findRoute(SharedApplicationRoute.gdppayrollEntry), findsOneWidget);
    });

    testWidgets('sem folha mostra traços e zeros', (tester) async {
      await pumpPage(tester, PayrollDetailPage());
      expect(find.text('-'), findsNWidgets(2));
      expect(find.text(currency.format(0)), findsNWidgets(3));
    });
  });

  group('PayrollEntryListPage', () {
    Future<PayrollEntryBloc> pumpEntries(WidgetTester tester,
        {bool withSession = true, bool settle = true, Payroll? arguments}) async {
      final bloc = env.entryBloc(withSession: withSession);
      final container = env.container()..register<PayrollEntryBloc>(bloc);
      await pumpPage(tester, PayrollEntryListPage(appContainer: container),
          arguments: arguments ?? payroll(), settle: settle);
      return bloc;
    }

    testWidgets('mostra o cabeçalho e os lançamentos', (tester) async {
      env.stubEntries('2026-08', [
        payrollEntryJson(),
        payrollEntryJson(id: 'PE2', title: 'INSS', value: 330.5),
      ]);
      final bloc = await pumpEntries(tester);

      expect(bloc.state, isA<PayrollEntryLoadedState>());
      expect(find.text('details'), findsOneWidget);
      expect(find.text('payroll_total_value'), findsOneWidget);
      expect(find.text(currency.format(10000.5)), findsOneWidget);
      expect(find.text(currency.format(1500.25)), findsOneWidget);
      expect(find.text(currency.format(8500.25)), findsOneWidget);
      expect(find.byType(PayrollEntryListItem), findsNWidgets(2));
      expect(find.text('PE1'), findsOneWidget);
      expect(find.text('Salário'), findsOneWidget);
      expect(find.text(currency.format(3000)), findsOneWidget);
      expect(find.text('INSS'), findsOneWidget);
      expect(find.text(currency.format(330.5)), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);
      await expectLater(find.byType(PayrollEntryListPage),
          matchesGoldenFile('goldens/payroll_entry_list_page.png'));
    });

    testWidgets('falha mostra a mensagem de erro', (tester) async {
      env.http.failAll();
      final bloc = await pumpEntries(tester);
      expect(bloc.state, isA<PayrollEntryLoadFailedState>());
      expect(find.text('payroll_error'), findsOneWidget);
    });

    testWidgets('enquanto carrega mostra o indicador', (tester) async {
      final bloc = await pumpEntries(tester, withSession: false, settle: false);
      expect(bloc.state, isA<PayrollEntryLoadingState>());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('PayrollEntryListItem', () {
    testWidgets('mostra id, descrição e valor; nulos viram "-"', (tester) async {
      await pumpApp(tester, PayrollEntryListItem(entry: payrollEntry()));
      expect(find.text('gdp_id'), findsOneWidget);
      expect(find.text('payroll_description'), findsOneWidget);
      expect(find.text('payroll_value'), findsOneWidget);
      expect(find.text('PE1'), findsOneWidget);
      expect(find.text('Salário'), findsOneWidget);
      expect(find.text(currency.format(3000)), findsOneWidget);
      await expectLater(findGoldenSurface(),
          matchesGoldenFile('goldens/payroll_entry_list_item.png'));

      await pumpApp(tester,
          PayrollEntryListItem(entry: payrollEntry(id: null, title: null, value: null)));
      expect(find.text('-'), findsNWidgets(3));
    });
  });
}
