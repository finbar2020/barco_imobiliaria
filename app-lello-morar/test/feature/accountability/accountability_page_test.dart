import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/accountability/domain/entity/accountability.dart';
import 'package:morar/feature/accountability/domain/entity/accountability_grouped.dart';
import 'package:morar/feature/accountability/domain/entity/accountability_grouped_account.dart';
import 'package:morar/feature/accountability/domain/entity/accountability_grouped_account_entrie.dart';
import 'package:morar/feature/accountability/presentation/bloc/accountabiity_state.dart';
import 'package:morar/feature/accountability/presentation/controllers/accountability_controller.dart';
import 'package:morar/feature/accountability/presentation/page/accountability_info_details_page.dart';
import 'package:morar/feature/accountability/presentation/page/accountability_info_page.dart';
import 'package:morar/feature/accountability/presentation/page/accountability_page.dart';
import 'package:morar/feature/accountability/presentation/widgets/accountability_info_details_page/accountability_info_details_entry_item_widget.dart';
import 'package:morar/feature/accountability/presentation/widgets/accountability_info_details_page/accountability_info_details_entry_widget.dart';
import 'package:morar/feature/accountability/presentation/widgets/accountability_info_details_page/accountability_info_details_summary_widget.dart';
import 'package:morar/feature/accountability/presentation/widgets/accountability_info_page/accountability_group_summary_widget.dart';
import 'package:morar/feature/accountability/presentation/widgets/accountability_info_page/accountability_period_group_list_widget.dart';
import 'package:morar/feature/accountability/presentation/widgets/accountability_info_page/accountability_period_summary_widget.dart';
import 'package:morar/feature/session/domain/entity/session.dart';
import 'package:morar/feature/session/presentation/bloc/session_state.dart';
import 'package:shared_features/shared_features.dart' show SharedApplicationRoute;

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'accountability_page_helpers.dart';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;

  late Map<String, String> loc;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
    // O `S.load` do MaterialApp muda o `Intl.defaultLocale` para pt_BR no
    // meio do teste; fixamos antes para os nomes dos meses (gerados com
    // `DateFormat('MMMM')`) baterem com a lista de meses da localização.
    await initializeDateFormatting('pt_BR');
    Intl.defaultLocale = 'pt_BR';
    loc = {'accountability_month_list': monthList()};
  });

  final routes = <String, WidgetBuilder>{
    ApplicationRoute.accountability: (_) => const AccountabilityPage(),
    ApplicationRoute.accountabilityInfo: (_) => const AccountabilityInfoPage(),
    ApplicationRoute.accountabilityInfoDetails: (_) =>
        const AccountabilityInfoDetailsPage(),
  };

  AccountabilityController controller() =>
      harness.resolve<AccountabilityController>();

  void mockPeriods(List<Map<String, dynamic>> periods) =>
      harness.http.on('GET', periodsPath, body: periods);

  Finder dropdown() =>
      find.byWidgetPredicate((w) => w is DropdownButton, description: 'dropdown');

  Future<void> selectPeriod(WidgetTester tester, String text) async {
    await tester.tap(dropdown());
    await tester.pumpAndSettle();
    await tester.tap(find.text(text).last);
    await tester.pumpAndSettle();
  }

  group('AccountabilityPage', () {
    testWidgets('lista os períodos e mostra o condomínio da sessão',
        (tester) async {
      mockPeriods([periodJson(2026, 1), periodJson(2025, 12)]);

      await pumpPage(tester, const AccountabilityPage(), locOverrides: loc);

      expect(harness.http.requests.single.url.path, periodsPath);
      expect(controller().bloc.state, isA<AccountabilityLoadedState>());
      expect(find.text('Edifício Lello - 101'), findsOneWidget);
      expect(find.text('accountability_choose_period'), findsOneWidget);
      expect(find.text('choose_an_option'), findsOneWidget);
      expect(find.text('find'), findsOneWidget);
      await expectLater(
        find.byType(AccountabilityPage),
        matchesGoldenFile('goldens/accountability_page.png'),
      );
    });

    testWidgets('sem períodos mostra a mensagem de vazio', (tester) async {
      mockPeriods([]);

      await pumpPage(tester, const AccountabilityPage(), locOverrides: loc);

      expect(controller().bloc.state, isA<AccountabilityInitialState>());
      expect(find.text('accountability_empty'), findsOneWidget);
    });

    testWidgets('estado de loading mostra o indicador', (tester) async {
      mockPeriods([periodJson(2026, 1)]);
      await pumpPage(tester, const AccountabilityPage(), locOverrides: loc);

      await emitState(tester, controller().bloc,
          const AccountabilityLoadingState(),
          settle: false);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('estado desconhecido renderiza vazio', (tester) async {
      mockPeriods([periodJson(2026, 1)]);
      await pumpPage(tester, const AccountabilityPage(), locOverrides: loc);

      // PeriodsLoaded não é tratado na tela de períodos: cai no Container().
      await emitState(
          tester,
          controller().bloc,
          AccountabilityPeriodsLoadedState(
              accountability: Accountability(condominiumId: 'c1')));

      expect(find.text('find'), findsNothing);
      expect(find.text('accountability_empty'), findsNothing);
    });

    testWidgets('erro mostra o widget de erro, retry recarrega e voltar fecha',
        (tester) async {
      harness.http.failAll();

      await pumpPage(
        tester,
        RouteLauncher(route: ApplicationRoute.accountability),
        routes: routes,
        observer: observer,
        locOverrides: loc,
      );
      expect(find.byType(ErrorHandlingWidget), findsOneWidget);

      await tester.tap(find.text('error_handling_widget_button_reTry').first);
      await tester.pumpAndSettle();
      expect(find.byType(ErrorHandlingWidget), findsOneWidget);
      expect(harness.http.requests, hasLength(2));

      mockPeriods([periodJson(2026, 1)]);
      await tester.tap(find.text('error_handling_widget_button_reTry').first);
      await tester.pumpAndSettle();
      expect(find.byType(ErrorHandlingWidget), findsNothing);
      expect(find.text('find'), findsOneWidget);
    });

    testWidgets('botão voltar do erro fecha a tela', (tester) async {
      harness.http.failAll();

      await pumpPage(
        tester,
        RouteLauncher(route: ApplicationRoute.accountability),
        routes: routes,
        observer: observer,
        locOverrides: loc,
      );

      await tester.tap(find.text('error_handling_widget_button_back').first);
      await tester.pumpAndSettle();
      expect(find.byType(AccountabilityPage), findsNothing);
      expect(findRoute(SharedApplicationRoute.home), findsOneWidget);
      expect(observer.popped, hasLength(1));
    });

    testWidgets('sem condomínio na sessão vai direto para o erro',
        (tester) async {
      harness.sessionBloc.currentState = SessionLoadedState(Session());

      await pumpPage(tester, const AccountabilityPage(), locOverrides: loc);

      expect(harness.http.requests, isEmpty);
      expect(find.byType(ErrorHandlingWidget), findsOneWidget);
    });

    testWidgets('buscar sem período selecionado não navega', (tester) async {
      mockPeriods([periodJson(2026, 1)]);
      await pumpPage(tester, const AccountabilityPage(),
          observer: observer, routes: routes, locOverrides: loc);

      await tester.tap(find.text('find'));
      await tester.pumpAndSettle();

      expect(observer.pushedNames.last, pageRouteName);
      expect(find.byType(AccountabilityPage), findsOneWidget);
    });

    testWidgets('selecionar um período e buscar abre a prestação do mês',
        (tester) async {
      mockPeriods([periodJson(2026, 1), periodJson(2025, 12)]);
      harness.http.on('GET', groupedPath('2026-01'), body: accountabilityJson());
      await pumpPage(tester, const AccountabilityPage(),
          observer: observer, routes: routes, locOverrides: loc);

      final january = '${monthName(1)} - 2026';
      await selectPeriod(tester, january);
      expect(find.text('choose_an_option'), findsNothing);

      await tester.tap(find.text('find'));
      await tester.pumpAndSettle();

      expect(observer.pushedNames.last, ApplicationRoute.accountabilityInfo);
      expect(harness.http.requests.map((r) => r.url.path),
          contains(groupedPath('2026-01')));
      expect(controller().bloc.state, isA<AccountabilityPeriodsLoadedState>());
      expect(find.byType(AccountabilityInfoPage), findsOneWidget);
      // Título vem do item selecionado no dropdown.
      expect(find.text(january), findsOneWidget);
      expect(find.byType(AccountabilityGroupSummaryWidget), findsNWidgets(2));
      expect(find.byType(AccountabilityPeriodSummaryWidget), findsOneWidget);
    });

    testWidgets('o período de dezembro converte o mês corretamente',
        (tester) async {
      mockPeriods([periodJson(2025, 12)]);
      harness.http.on('GET', groupedPath('2025-12'), body: accountabilityJson());
      await pumpPage(tester, const AccountabilityPage(),
          observer: observer, routes: routes, locOverrides: loc);

      await selectPeriod(tester, '${monthName(12)} - 2025');
      await tester.tap(find.text('find'));
      await tester.pumpAndSettle();

      final args = ModalRoute.of(
              tester.element(find.byType(AccountabilityInfoPage)))!
          .settings
          .arguments as AccountabilityInfoPageArgs;
      expect(args.period, DateTime(2025, 12, 1));
      expect(args.selectedDate, '${monthName(12)} - 2025');
    });

    testWidgets('contexto de notificação abre o mês automaticamente',
        (tester) async {
      mockPeriods([periodJson(2026, 3)]);
      harness.http.on('GET', groupedPath('2026-03'), body: accountabilityJson());

      await pumpPage(
        tester,
        const AccountabilityPage(),
        arguments: AccountabilityPageArgs(accountabilityNotificationContext: '3/2026'),
        observer: observer,
        routes: routes,
        locOverrides: loc,
      );

      expect(observer.pushedNames.last, ApplicationRoute.accountabilityInfo);
      expect(harness.http.requests.map((r) => r.url.path),
          contains(groupedPath('2026-03')));
      final args = ModalRoute.of(
              tester.element(find.byType(AccountabilityInfoPage)))!
          .settings
          .arguments as AccountabilityInfoPageArgs;
      expect(args.period, DateTime(2026, 3, 1));
      expect(args.selectedDate, '${monthName(3)} - 2026');
      expect(find.text('${monthName(3)} - 2026'), findsOneWidget);
    });

    testWidgets('contexto de notificação vazio não navega', (tester) async {
      mockPeriods([periodJson(2026, 3)]);

      await pumpPage(
        tester,
        const AccountabilityPage(),
        arguments: AccountabilityPageArgs(accountabilityNotificationContext: ''),
        observer: observer,
        routes: routes,
        locOverrides: loc,
      );

      expect(observer.pushedNames.last, pageRouteName);
      expect(find.byType(AccountabilityPage), findsOneWidget);
    });
  });

  group('AccountabilityInfoPage', () {
    final args = AccountabilityInfoPageArgs(
        selectedDate: 'Janeiro - 2026', period: DateTime(2026, 1));

    testWidgets('mostra os grupos, o resumo do período e abre os detalhes',
        (tester) async {
      harness.http.on('GET', groupedPath('2026-01'), body: accountabilityJson());
      // O controller é carregado antes de abrir a tela (como na tela de
      // períodos). Sem runAsync: o bloc precisa nascer na zona fake.
      controller().getAccountabilityController(DateTime(2026, 1));

      await pumpPage(tester, const AccountabilityInfoPage(),
          arguments: args, observer: observer, routes: routes, locOverrides: loc,
          surface: const Size(400, 900));

      expect(find.text('Janeiro - 2026'), findsOneWidget);
      expect(find.text('accountability_historial_releases'), findsOneWidget);
      expect(find.byType(AccountabilityPeriodGroupListWidget), findsOneWidget);
      expect(find.text('Despesas administrativas'), findsOneWidget);
      expect(find.text('Receitas'), findsOneWidget);
      expect(find.text('accountability_initial_balance'), findsOneWidget);
      expect(find.text('accountability_balance'), findsOneWidget);
      expect(find.textContaining('1.200,00'), findsOneWidget);
      await expectLater(
        find.byType(AccountabilityInfoPage),
        matchesGoldenFile('goldens/accountability_info_page.png'),
      );

      await tester.tap(find.text('accountability_details').first);
      await tester.pumpAndSettle();

      expect(observer.pushedNames.last, ApplicationRoute.accountabilityInfoDetails);
      expect(find.byType(AccountabilityInfoDetailsPage), findsOneWidget);
      final detailArgs = ModalRoute.of(
              tester.element(find.byType(AccountabilityInfoDetailsPage)))!
          .settings
          .arguments as AccountabilityInfoDetailsPageArgs;
      expect(detailArgs.accountabilityGrouped.description,
          'Despesas administrativas');
    });

    testWidgets('loading mostra o indicador', (tester) async {
      await pumpPage(tester, const AccountabilityInfoPage(),
          arguments: args, settle: false, locOverrides: loc);
      await emitState(tester, controller().bloc,
          const AccountabilityLoadingState(),
          settle: false);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('estado inicial renderiza vazio', (tester) async {
      await pumpPage(tester, const AccountabilityInfoPage(),
          arguments: args, locOverrides: loc);

      expect(find.byType(AccountabilityPeriodGroupListWidget), findsNothing);
      expect(find.byType(ErrorHandlingWidget), findsNothing);
      expect(find.text('accountability_title'), findsOneWidget);
    });

    testWidgets('erro permite tentar de novo e voltar', (tester) async {
      harness.http.failAll();
      controller().getAccountabilityController(DateTime(2026, 1));

      await pumpPage(
        tester,
        RouteLauncher(route: ApplicationRoute.accountabilityInfo, arguments: args),
        routes: routes,
        observer: observer,
        locOverrides: loc,
      );
      expect(find.byType(ErrorHandlingWidget), findsOneWidget);
      expect(find.text('back_to_the_previous_page'), findsOneWidget);

      harness.http.on('GET', groupedPath('2026-01'), body: accountabilityJson());
      await tester.tap(find.text('error_handling_widget_button_reTry').first);
      await tester.pumpAndSettle();
      expect(find.byType(AccountabilityPeriodGroupListWidget), findsOneWidget);

      harness.http.failAll();
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      // O botão da app bar faz pop direto (sem passar pelo WillPopScope).
      expect(find.byType(AccountabilityInfoPage), findsNothing);
      expect(findRoute(SharedApplicationRoute.home), findsOneWidget);
    });

    testWidgets('botão voltar do erro fecha a tela', (tester) async {
      harness.http.failAll();
      controller().getAccountabilityController(DateTime(2026, 1));

      await pumpPage(
        tester,
        RouteLauncher(route: ApplicationRoute.accountabilityInfo, arguments: args),
        routes: routes,
        observer: observer,
        locOverrides: loc,
      );

      await tester.tap(find.text('back_to_the_previous_page'));
      await tester.pumpAndSettle();

      expect(find.byType(AccountabilityInfoPage), findsNothing);
      expect(findRoute(SharedApplicationRoute.home), findsOneWidget);
    });

    testWidgets('voltar pelo sistema volta para a tela de períodos',
        (tester) async {
      harness.http.on('GET', groupedPath('2026-01'), body: accountabilityJson());
      mockPeriods([periodJson(2026, 1)]);
      controller().getAccountabilityController(DateTime(2026, 1));

      await pumpPage(
        tester,
        RouteLauncher(route: ApplicationRoute.accountabilityInfo, arguments: args),
        routes: routes,
        observer: observer,
        locOverrides: loc,
      );

      /// Corrigido: `onWillPop` faz `pushReplacementNamed(accountability)` e
      /// devolve `false`; antes devolvia `true` e o Navigator removia também
      /// a rota recém-empurrada, levando à tela anterior à prestação.
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      await navigator.maybePop();
      await tester.pumpAndSettle();

      expect(observer.pushedNames, contains(ApplicationRoute.accountability));
      expect(find.byType(AccountabilityInfoPage), findsNothing);
      expect(find.byType(AccountabilityPage), findsOneWidget);
    });
  });

  group('AccountabilityInfoDetailsPage', () {
    testWidgets('mostra o resumo do grupo e os lançamentos de cada conta',
        (tester) async {
      final grouped = AccountabilityGrouped(
        type: 'D',
        description: 'Despesas administrativas',
        id: 1,
        debits: 300,
        credits: 0,
        accounts: [
          AccountabilityGroupedAccount(
            account: 101,
            description: 'Conta de luz',
            entries: [
              AccountabilityGroupedAccountEntrie(
                id: 1,
                date: DateTime(2026, 1, 5),
                value: -200,
                signal: '-',
                credit: 0,
                debit: 200,
                history: 'Pagamento Enel',
              ),
              AccountabilityGroupedAccountEntrie(
                id: 2,
                date: DateTime(2026, 1, 9),
                value: 50,
                signal: '+',
                credit: 50,
                debit: 0,
                history: 'Estorno',
              ),
            ],
          ),
          AccountabilityGroupedAccount(
            account: 102,
            description: 'Conta de água',
            entries: [
              AccountabilityGroupedAccountEntrie(
                id: 3,
                date: DateTime(2026, 1, 12),
                value: -100,
                signal: '-',
                credit: 0,
                debit: 100,
                history: 'Pagamento Sabesp',
              ),
            ],
          ),
        ],
      );

      await pumpPage(
        tester,
        const AccountabilityInfoDetailsPage(),
        arguments: AccountabilityInfoDetailsPageArgs(accountabilityGrouped: grouped),
        locOverrides: loc,
        surface: const Size(400, 1100),
      );

      expect(find.byType(AccountabilityInfoDetailsSummaryWidget), findsOneWidget);
      expect(find.text('Despesas administrativas'), findsOneWidget);
      expect(find.byType(AccountabilityInfoDetailsEntryWidget), findsNWidgets(2));
      expect(find.byType(AccountabilityInfoDetailsEntryItemWidget), findsNWidgets(3));
      expect(find.text('Conta de luz'), findsOneWidget);
      expect(find.text('101'), findsOneWidget);
      expect(find.text('Pagamento Enel'), findsOneWidget);
      expect(find.text('05/01/2026'), findsOneWidget);
      expect(find.text('Estorno'), findsOneWidget);
      expect(find.text('Pagamento Sabesp'), findsOneWidget);
      await expectLater(
        find.byType(AccountabilityInfoDetailsPage),
        matchesGoldenFile('goldens/accountability_info_details_page.png'),
      );
    });
  });
}
