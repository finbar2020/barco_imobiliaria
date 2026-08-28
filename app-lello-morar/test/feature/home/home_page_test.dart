import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_all_info.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_rule.dart';
import 'package:morar/feature/agreements/domain/entity/agreements_quotas.dart';
import 'package:morar/feature/agreements/domain/use_case/get_all_info/get_all_info.dart';
import 'package:morar/feature/home/domain/entity/home_item_enum.dart';
import 'package:morar/feature/home/presentation/bloc/home_bloc.dart';
import 'package:morar/feature/home/presentation/widget/agreements_dialog.dart';
import 'package:morar/feature/home/presentation/widget/bella_search_component.dart';
import 'package:morar/feature/home/presentation/widget/dashboard_item.dart';
import 'package:morar/feature/home/presentation/widget/empty_state_widget.dart';
import 'package:morar/feature/home/presentation/widget/expiration_dialog.dart';
import 'package:morar/feature/home/presentation/widget/home_app_bar.dart';
import 'package:morar/feature/home/presentation/widget/pages/comodities_page.dart';
import 'package:morar/feature/home/presentation/widget/pages/easy_fix_page.dart';
import 'package:morar/feature/home/presentation/widget/pages/home_page.dart';
import 'package:morar/feature/home/presentation/widget/pages/unity_page.dart';
import 'package:morar/feature/session/domain/entity/session.dart';
import 'package:shared_features/feature/banners/presentation/widgets/banners_widget.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_page.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'home_test_support.dart';

class _FakeGetAvailable extends Fake implements GetAvailableUseCase {
  @override
  Future<Try<AgreementAllInfo>> call(GetAvailableParams p) async =>
      Success(AgreementAllInfo(
        quotes: [
          AgreementQuota(
            id: 'q1',
            receipt: 'r1',
            originValue: 10,
            dueDate: DateTime(2026, 1, 1),
            fineValue: 1,
            feeValue: 1,
            honoraryValue: 1,
            overdueMessage: '',
          ),
        ],
        agreements: [],
        rule: AgreementRule(installmentQtd: 1, days: [1], paymentMethod: []),
      ));
}

final _sessionBloc = HomeFakeSessionBloc();

/// Todos os rbacs da home menos os banners (que dependem do banco local).
Set<String> _rbacsSemBanner() => {
      ...HomeItemEnum.values.map((e) => e.rbac(_sessionBloc)),
      ApplicationRbac.morarIaBella,
      ApplicationRbac.morarComodidades,
    };

Map<String, dynamic> _subUser({
  String id = 'm1',
  String role = 'morar.proprietario',
  DateTime? expiresAt,
  String? status,
}) =>
    {
      'id': id,
      'role': role,
      'expires_at': expiresAt?.toIso8601String(),
      'access_renewal_request_status': status,
    };

/// Deixa o IO real (banco local dos banners) andar antes de assentar a tela.
Future<void> settleIo(WidgetTester tester, {int rounds = 4}) async {
  for (var i = 0; i < rounds; i++) {
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 60)));
    await tester.pump();
  }
}

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installHomeHarness(_sessionBloc);
    stubHomeApis(harness);
    _sessionBloc.allowedRbacs = _rbacsSemBanner();
    observer = RecordingNavigatorObserver();
    mockHomePlatformChannels();
    AgreementsDialog.agreementsInfo = null;
  });

  group('HomePage', () {
    Future<void> pumpHome(
      WidgetTester tester, {
      List<String>? log,
      bool settle = true,
      bool isGeneric = false,
    }) async {
      await pumpPage(
        tester,
        Scaffold(
          body: HomePage(
            closeOverlay: () => log?.add('close'),
            pictureOnTap: () => log?.add('picture'),
            onNavigateToComodidades: () => log?.add('comodidades'),
            isGeneric: isGeneric,
          ),
        ),
        observer: observer,
        settle: settle,
        surface: const Size(500, 1000),
      );
    }

    testWidgets('mostra saudação, Bella e os acessos recentes',
        (tester) async {
      await pumpHome(tester);
      expect(find.text('hi, Ana'), findsOneWidget);
      expect(find.byType(BellaSearchComponent), findsOneWidget);
      expect(find.text('Acessos recentes'), findsOneWidget);
      expect(find.byType(DashboardItem), findsNWidgets(3));
      expect(find.text('income_control_billets'), findsOneWidget);
      expect(find.byType(BannersWidget), findsNothing);

      await expectLater(
        find.byType(HomePage),
        matchesGoldenFile('goldens/home_page.png'),
      );
    });

    testWidgets('com banners liberados monta o widget de banners',
        (tester) async {
      _sessionBloc.allowedRbacs = null;
      await pumpHome(tester, settle: false);
      await settleIo(tester);
      expect(find.byType(BannersWidget), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('sem nenhum acesso mostra o estado vazio', (tester) async {
      _sessionBloc.allowedRbacs = {};
      await pumpHome(tester);
      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.byType(BellaSearchComponent), findsNothing);

      // Só a Bella liberada já basta para montar o corpo.
      _sessionBloc.allowedRbacs = {ApplicationRbac.morarIaBella};
      await tester.pumpWidget(const SizedBox());
      await pumpHome(tester);
      expect(find.byType(EmptyStateWidget), findsNothing);
      expect(find.byType(BellaSearchComponent), findsOneWidget);
      expect(find.byType(DashboardItem), findsNothing);
    });

    testWidgets('estrela abre as preferências e para a animação',
        (tester) async {
      await pumpHome(tester);
      final bloc = harness.resolve<HomeBloc>();
      await tester.tap(find.byIcon(Icons.star));
      await tester.pumpAndSettle();
      expect(bloc.animate.value, isFalse);
      expect(observer.pushedNames.last, ApplicationRoute.preferencesHome);
    });

    testWidgets('tocar em um card fecha o overlay e atualiza a ordem',
        (tester) async {
      final log = <String>[];
      await pumpHome(tester, log: log);
      await tester.tap(find.text('reserves'));
      await tester.pumpAndSettle();
      expect(log, ['close']);
      expect(observer.pushedNames.last, ApplicationRoute.reserve);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getStringList('home_item_order_v2')?.first, 'reserves');
    });

    testWidgets('card de comodidades usa o callback da aba', (tester) async {
      final log = <String>[];
      SharedPreferences.setMockInitialValues({
        'PREFERENCES_HOME_CARDS_ONBOARDING12345678901': '{"onboarding": true}',
        'home_item_order_v2': ['comfort'],
      });
      await pumpHome(tester, log: log);
      expect(find.text('comfort'), findsOneWidget);
      await tester.tap(find.text('comfort'));
      await tester.pumpAndSettle();
      expect(log, ['close', 'comodidades']);
    });

    testWidgets('diálogo de acordos e depois o de expiração do proprietário',
        (tester) async {
      await harness.override<GetAvailableUseCase>(_FakeGetAvailable());
      harness.http.on('GET', '/concierge/subUser/u1', body: [
        _subUser(),
        _subUser(
            id: 'm2',
            role: 'morar.morador',
            expiresAt: DateTime.now().add(const Duration(days: 5))),
      ]);
      await pumpHome(tester);
      expect(find.byType(AgreementsDialogWidget), findsOneWidget);

      await tester.tap(find.text('LATER'));
      await tester.pumpAndSettle();
      expect(find.byType(AgreementsDialogWidget), findsNothing);
      expect(find.byType(ExpirationDialog), findsOneWidget);
      final dialog =
          tester.widget<ExpirationDialog>(find.byType(ExpirationDialog));
      expect(dialog.isOwner, isTrue);

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('show_expiration_dialog'), isFalse);

      await tester.tap(find.text('Fechar'));
      await tester.pumpAndSettle();
      expect(find.byType(ExpirationDialog), findsNothing);
    });

    testWidgets('morador com acesso vencendo solicita a renovação',
        (tester) async {
      harness.http.on('GET', '/concierge/subUser/u1', body: [
        _subUser(
            role: 'morar.morador',
            expiresAt: DateTime.now().add(const Duration(days: 5))),
      ]);
      harness.http.on('POST', '/concierge/subUser/renew_access/u1',
          body: 'ok');
      await pumpHome(tester);
      expect(find.byType(ExpirationDialog), findsOneWidget);
      expect(tester.widget<ExpirationDialog>(find.byType(ExpirationDialog)).isOwner,
          isFalse);

      await tester.tap(find.text('Solicitar renovação'));
      await tester.pumpAndSettle();
      expect(
        harness.http.requests.map((r) => r.url.path),
        contains('/concierge/subUser/renew_access/u1'),
      );
      expect(observer.pushed.length, greaterThan(2));
    });

    testWidgets('preferência desativa o diálogo de expiração', (tester) async {
      SharedPreferences.setMockInitialValues({
        'PREFERENCES_HOME_CARDS_ONBOARDING12345678901': '{"onboarding": true}',
        'show_expiration_dialog': false,
      });
      harness.http.on('GET', '/concierge/subUser/u1', body: [
        _subUser(expiresAt: DateTime.now().add(const Duration(days: 5))),
      ]);
      await pumpHome(tester);
      expect(find.byType(ExpirationDialog), findsNothing);
    });

    testWidgets('ciclo de vida reinicia e para o temporizador de analytics',
        (tester) async {
      await pumpHome(tester);
      final state = tester.state(find.byType(HomePage)) as dynamic;
      final binding = tester.binding;

      // Com outra rota por cima o ciclo de vida é ignorado.
      tester.state<NavigatorState>(find.byType(Navigator))
          .pushNamed(ApplicationRoute.me);
      await tester.pumpAndSettle();
      binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await tester.pumpAndSettle();

      for (final lifecycle in [
        AppLifecycleState.inactive,
        AppLifecycleState.hidden,
        AppLifecycleState.paused,
        AppLifecycleState.hidden,
        AppLifecycleState.inactive,
        AppLifecycleState.resumed,
        AppLifecycleState.inactive,
        AppLifecycleState.hidden,
        AppLifecycleState.paused,
        AppLifecycleState.detached,
      ]) {
        binding.handleAppLifecycleStateChanged(lifecycle);
        await tester.pump();
      }
      expect(tester.takeException(), isNull);

      expect(state.addSoftHyphens('abcdefghijkl'), 'abcdef\u00ADghijkl');
      expect(state.hyphenateText('abcdefghijklmnop'), 'abcdefghi-\u200Bjklmnop');
      expect(state.hyphenateText('curto'), 'curto');
      expect(state.hyphenateText('duas palavras'), 'duas palavras');
      expect(state.getFavoritesCards(<HomeItemEnum>[], [HomeItemEnum.billets]),
          [HomeItemEnum.billets]);
      expect(
          state.getFavoritesCards([HomeItemEnum.comfort], [HomeItemEnum.billets]),
          [HomeItemEnum.comfort]);
      binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
    });

    testWidgets('sem usuário na sessão a saudação fica vazia', (tester) async {
      _sessionBloc.session = Session();
      _sessionBloc.allowedRbacs = {};
      SharedPreferences.setMockInitialValues({
        'PREFERENCES_HOME_CARDS_ONBOARDINGnull': '{"onboarding": true}',
      });
      await pumpHome(tester);
      expect(find.text('hi, Ana'), findsNothing);
      expect(find.byType(EmptyStateWidget), findsOneWidget);
    });
  });

  group('EasyFixPage', () {
    Future<void> pumpEasyFix(WidgetTester tester, {bool settle = true}) async {
      await pumpPage(
        tester,
        Scaffold(body: EasyFixPage(closeOverlay: () {})),
        observer: observer,
        settle: settle,
        surface: const Size(500, 1200),
      );
    }

    testWidgets('lista todos os cards e abre a Bella pelo botão',
        (tester) async {
      await pumpEasyFix(tester);
      expect(find.text('easy_fix'), findsOneWidget);
      expect(find.byType(DashboardItem), findsNWidgets(8));
      expect(find.byType(EmptyStateWidget), findsNothing);

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(observer.pushedNames.last, ApplicationRoute.iaBella);
    });

    testWidgets('cada card navega e atualiza o cache de ordem', (tester) async {
      await pumpEasyFix(tester);
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      for (final entry in {
        'cnd': ApplicationRoute.certificateNoOutstandingDebt,
        'my_preferences': ApplicationRoute.myPreferences,
        'documents': ApplicationRoute.documents,
        'lello_hub_billing': ApplicationRoute.accountability,
        'income_control_billets': ApplicationRoute.billets,
        'reserves': ApplicationRoute.reserve,
        'agreements': ApplicationRoute.agreements,
        'change_ownership': ApplicationRoute.changeOwnership,
      }.entries) {
        await tester.ensureVisible(find.text(entry.key));
        await tester.tap(find.text(entry.key));
        await tester.pumpAndSettle();
        expect(observer.pushedNames.last, entry.value, reason: entry.key);
        navigator.pop();
        await tester.pumpAndSettle();
      }
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getStringList('home_item_order_v2')?.first,
          'changeOwnership');
      expect(prefs.getStringList('home_item_order_v2'), hasLength(8));
    });

    testWidgets('sem acesso mostra o estado vazio', (tester) async {
      _sessionBloc.allowedRbacs = {};
      await pumpEasyFix(tester);
      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.byType(DashboardItem), findsNothing);
      expect(find.byType(IconButton), findsNothing);
    });

    testWidgets('com banners liberados monta o widget de banners',
        (tester) async {
      _sessionBloc.allowedRbacs = {
        ApplicationRbac.morarBanner,
        ApplicationRbac.morarBoletos,
      };
      await pumpEasyFix(tester, settle: false);
      await settleIo(tester);
      expect(find.byType(BannersWidget), findsOneWidget);
      expect(find.byType(DashboardItem), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  });

  group('UnityPage', () {
    Future<void> pumpUnity(WidgetTester tester, {bool settle = true}) async {
      await pumpPage(
        tester,
        Scaffold(body: UnityPage(closeOverlay: () {})),
        observer: observer,
        settle: settle,
        surface: const Size(500, 1200),
      );
    }

    testWidgets('lista todos os cards e abre a Bella pelo botão',
        (tester) async {
      await pumpUnity(tester);
      expect(find.text('units_title'), findsOneWidget);
      expect(find.byType(DashboardItem), findsNWidgets(7));

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(observer.pushedNames.last, ApplicationRoute.iaBella);
    });

    testWidgets('cada card navega e atualiza o cache de ordem', (tester) async {
      await pumpUnity(tester);
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      for (final entry in {
        'insurance': ApplicationRoute.insurance,
        'condominium_hub_residents': ApplicationRoute.subUser,
        'digital_meeting': ApplicationRoute.digitalMeeting,
        'me_vehicles_title': ApplicationRoute.vehiclePage,
        'mailing_title': ApplicationRoute.mailing,
        'reports_title': ApplicationRoute.reports,
        'authorize_entry': ApplicationRoute.accessControl,
      }.entries) {
        await tester.ensureVisible(find.text(entry.key));
        await tester.tap(find.text(entry.key));
        await tester.pumpAndSettle();
        expect(observer.pushedNames.last, entry.value, reason: entry.key);
        navigator.pop();
        await tester.pumpAndSettle();
      }
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getStringList('home_item_order_v2'), hasLength(7));
    });

    testWidgets('sem acesso mostra o estado vazio', (tester) async {
      _sessionBloc.allowedRbacs = {};
      await pumpUnity(tester);
      expect(find.byType(EmptyStateWidget), findsOneWidget);
    });

    testWidgets('com banners liberados monta o widget de banners',
        (tester) async {
      _sessionBloc.allowedRbacs = {
        ApplicationRbac.morarBanner,
        ApplicationRbac.morarMoradores,
      };
      await pumpUnity(tester, settle: false);
      await settleIo(tester);
      expect(find.byType(BannersWidget), findsOneWidget);
      expect(find.byType(DashboardItem), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  });

  group('ComoditiesPage', () {
    testWidgets('com acesso monta a página de comodidades embutida',
        (tester) async {
      _sessionBloc.allowedRbacs = null;
      harness.http.on('GET', '/condominiums/c1/comfort/v2', body: {'data': []});
      await pumpPage(
        tester,
        Scaffold(body: ComoditiesPage(closeOverlay: () {})),
        settle: false,
        surface: const Size(500, 1200),
      );
      await settleIo(tester);
      expect(find.text('comfort'), findsOneWidget);
      expect(find.byType(ComfortPage), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('sem acesso não monta nada além do título', (tester) async {
      _sessionBloc.allowedRbacs = {};
      await pumpPage(tester, Scaffold(body: ComoditiesPage(closeOverlay: () {})));
      expect(find.text('comfort'), findsOneWidget);
      expect(find.byType(ComfortPage), findsNothing);
    });
  });

  group('HomeAppBar', () {
    Future<void> pumpAppBar(
      WidgetTester tester,
      List<String> log, {
      bool open = false,
    }) async {
      final bloc = harness.resolve<NotificationListBloc>();
      await pumpPage(
        tester,
        Scaffold(
          body: HomeAppBar(
            gestureOnTap: () => log.add('gesture'),
            pictureOnTap: () => log.add('picture'),
            onNotificationTap: () => log.add('notification'),
            notificationListBloc: bloc,
            isDropdownOpen: open,
          ),
        ),
      );
    }

    testWidgets('mostra condomínio, unidade e responde aos toques',
        (tester) async {
      final log = <String>[];
      await pumpAppBar(tester, log);
      expect(find.text('Edifício Lello'), findsOneWidget);
      expect(find.textContaining('101'), findsOneWidget);

      await tester.tap(find.text('Edifício Lello'));
      await tester.tap(find.byType(GestureDetector).last);
      await tester.pumpAndSettle();
      expect(log, contains('gesture'));
      expect(log, contains('picture'));
    });

    testWidgets('badge mostra a quantidade de não lidas', (tester) async {
      final log = <String>[];
      await pumpAppBar(tester, log, open: true);
      final bloc = harness.resolve<NotificationListBloc>();
      await emitState(
          tester, bloc, NotificationListPageState(notificationsNotRead: 7));
      expect(find.text('7'), findsOneWidget);

      await emitState(
          tester, bloc, NotificationListPageState(notificationsNotRead: 150));
      expect(find.text('99+'), findsOneWidget);

      await tester.tap(find.text('99+'));
      await tester.pumpAndSettle();
      expect(log, ['notification']);

      await emitState(
          tester, bloc, NotificationListPageState(notificationsNotRead: 0));
      expect(find.text('99+'), findsNothing);
    });

    testWidgets('sem usuário usa o ícone padrão', (tester) async {
      _sessionBloc.session = Session();
      await pumpAppBar(tester, []);
      expect(find.byType(HomeAppBar), findsOneWidget);
      expect(find.textContaining(' - '), findsNothing);
    });
  });
}
