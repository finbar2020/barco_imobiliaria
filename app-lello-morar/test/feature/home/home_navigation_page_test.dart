import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/billets/presentation/pages/billets_page.dart';
import 'package:morar/feature/home/domain/entity/home_item_enum.dart';
import 'package:morar/feature/home/presentation/page/home_navigation_page.dart';
import 'package:morar/feature/home/presentation/widget/empty_state_widget.dart';
import 'package:morar/feature/home/presentation/widget/home_app_bar.dart';
import 'package:morar/feature/home/presentation/widget/home_dialogs/widgets/switch_role_alert_dialog/switch_role_alert_dialog_widget.dart';
import 'package:morar/feature/home/presentation/widget/pages/comodities_page.dart';
import 'package:morar/feature/home/presentation/widget/pages/easy_fix_page.dart';
import 'package:morar/feature/home/presentation/widget/pages/home_page.dart';
import 'package:morar/feature/home/presentation/widget/pages/unity_page.dart';
import 'package:morar/feature/home/presentation/widget/unit_selection_overlay.dart';
import 'package:morar/feature/session/domain/entity/session.dart';
import 'package:morar/feature/session/presentation/bloc/session_state.dart';
import 'package:morar/lello_app.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:shared_features/core/modal/theme_color_dialog.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/fake_permission_handler.dart';
import '../../helpers/firebase_mocks.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'home_test_support.dart';

final _sessionBloc = HomeFakeSessionBloc();

/// Todos os rbacs da home menos banners e comodidades (dependem de banco
/// local / páginas compartilhadas com loading infinito).
Set<String> _rbacsBasicos() => {
      ...HomeItemEnum.values.map((e) => e.rbac(_sessionBloc)),
      ApplicationRbac.morarIaBella,
      ApplicationRbac.morarPreferenciasNotificacoes,
    }..remove(ApplicationRbac.morarComodidades);

Finder findSvg(String asset) => find.byWidgetPredicate((w) =>
    w is SvgPicture &&
    w.bytesLoader is SvgAssetLoader &&
    (w.bytesLoader as SvgAssetLoader).assetName == asset);

/// Sessão com duas unidades em condomínios diferentes (contextos de
/// notificação `ctx-u1` e `ctx-u2`).
Session _sessaoDuasUnidades() {
  final me = testMe(condominiums: [
    testCondominium(),
    testCondominium(
      id: 'c2',
      reference: 'R2',
      name: 'Condomínio Sol',
      blocks: [
        testBlock(id: 'b2', units: [
          testUnity(id: 'u2', title: '202', notificationContext: 'ctx-u2'),
        ])
      ],
    ),
  ]);
  return testSession(me: me);
}

SharedApplicationRedirectRoute _redirect({
  String rote = 'BOLETOS',
  String? context = 'ctx-u1',
  String? objectId = 'obj',
  bool inApp = false,
}) =>
    SharedApplicationRedirectRoute(
      rote: rote,
      context: context,
      objectId: objectId,
      notificationId: 'n1',
      inApp: inApp,
      uuidGroup: 'g1',
    );

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;
  late List<dynamic> platformCalls;

  setUp(() async {
    harness = await installHomeHarness(_sessionBloc);
    stubHomeApis(harness);
    _sessionBloc.allowedRbacs = _rbacsBasicos();
    observer = RecordingNavigatorObserver();
    platformCalls = mockHomePlatformChannels();
  });

  Future<void> pumpNav(
    WidgetTester tester, {
    HomeNavigationPageArgs? args,
    bool isGeneric = false,
    Function(ThemeData)? changeTheme,
    bool settle = true,
  }) async {
    await pumpPage(
      tester,
      HomeNavigationPage(
        isGeneric: isGeneric,
        changeTheme: changeTheme,
        talkToLelloWhatsAppNumber: '5511',
      ),
      arguments: args,
      observer: observer,
      settle: settle,
      surface: const Size(500, 1000),
      locOverrides: const {
        // As chaves em maiúsculo estouram a largura do diálogo de troca.
        'switch_role_alert_not_now': 'Agora não',
        'switch_role_alert_take_me_there': 'Me leve',
      },
    );
  }

  /// `addPostFrameCallback` não agenda frame; fora de um build é preciso
  /// pedir um para os redirecionamentos rodarem.
  Future<void> settleWithFrame(WidgetTester tester) async {
    tester.binding.scheduleFrame();
    await tester.pumpAndSettle();
  }

  dynamic navState(WidgetTester tester) =>
      tester.state(find.byType(HomeNavigationPage));

  Future<void> tapTab(WidgetTester tester, String asset) async {
    await tester.tap(findSvg(asset).first, warnIfMissed: false);
    await tester.pumpAndSettle();
  }

  group('montagem', () {
    testWidgets('mostra a home, a app bar e as abas', (tester) async {
      await pumpNav(tester);
      expect(find.byType(HomeAppBar), findsOneWidget);
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(EasyFixPage, skipOffstage: false), findsOneWidget);
      expect(find.byType(UnityPage, skipOffstage: false), findsOneWidget);
      expect(find.byType(ComoditiesPage, skipOffstage: false), findsNothing);
      expect(find.text('hi, Ana'), findsOneWidget);
      expect(
        harness.http.requests.map((r) => r.url.path),
        contains('/dashboard/u1/pendencies/pagination'),
      );

      await expectLater(
        find.byType(HomeNavigationPage),
        matchesGoldenFile('goldens/home_navigation_page.png'),
      );
    });

    testWidgets('sem nenhum acesso mostra o estado vazio sem abas',
        (tester) async {
      _sessionBloc.allowedRbacs = {};
      await pumpNav(tester);
      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.byType(HomePage), findsNothing);
      expect(findSvg('assets/ic_home.svg'), findsNothing);
    });

    testWidgets('permissão de notificação negada abre a tela de permissão',
        (tester) async {
      setFakePermissionHandler(
          FakePermissionHandler(status: PermissionStatus.denied));
      await pumpNav(tester);
      expect(findRoute(ApplicationRoute.permissionNotification), findsOneWidget);

      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });
  });

  group('abas e overlay', () {
    testWidgets('troca de aba pela barra e volta para a home pelo back',
        (tester) async {
      await pumpNav(tester);
      expect(find.text('easy_fix'), findsNothing);

      await tapTab(tester, 'assets/ic_easy_fix.svg');
      expect(find.text('easy_fix'), findsOneWidget);
      expect(find.text('hi, Ana'), findsNothing);

      await tapTab(tester, 'assets/ic_unity.svg');
      expect(find.text('units_title'), findsOneWidget);

      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      await navigator.maybePop();
      await tester.pumpAndSettle();
      expect(find.text('hi, Ana'), findsOneWidget);

      // Já na home, o back é entregue ao sistema (a rota é fechada).
      await navigator.maybePop();
      await tester.pumpAndSettle();
      expect(find.byType(HomeNavigationPage), findsNothing);
      expect(observer.popped, isNotEmpty);
    });

    testWidgets('overlay de unidades abre, seleciona e fecha', (tester) async {
      _sessionBloc.session = _sessaoDuasUnidades();
      await pumpNav(tester);

      await tester.tap(find.text('Edifício Lello'));
      await tester.pumpAndSettle();
      expect(find.byType(UnitSelectionOverlay), findsOneWidget);

      // Voltar do sistema fecha o overlay.
      await tester.state<NavigatorState>(find.byType(Navigator)).maybePop();
      await tester.pumpAndSettle();
      expect(find.byType(UnitSelectionOverlay), findsNothing);

      await tester.tap(find.text('Edifício Lello'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.keyboard_arrow_up_rounded));
      await tester.pumpAndSettle();
      expect(find.byType(UnitSelectionOverlay), findsNothing);

      await tester.tap(find.text('Edifício Lello'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('CONDOMÍNIO SOL'));
      await tester.pumpAndSettle();
      expect(find.byType(UnitSelectionOverlay), findsNothing);
      expect(_sessionBloc.selectedUnits.single.id, 'u2');
      expect(_sessionBloc.session.condominium?.id, 'c2');
    });

    testWidgets('tocar no corpo fecha o overlay', (tester) async {
      await pumpNav(tester);
      await tester.tap(find.text('Edifício Lello'));
      await tester.pumpAndSettle();
      expect(find.byType(UnitSelectionOverlay), findsOneWidget);

      navState(tester).closeOverLay();
      await tester.pumpAndSettle();
      expect(find.byType(UnitSelectionOverlay), findsNothing);
      navState(tester).closeOverLay();
      await tester.pump();
    });

    testWidgets('aba atual some quando os acessos mudam', (tester) async {
      await pumpNav(tester);
      await tapTab(tester, 'assets/ic_unity.svg');
      expect(find.text('units_title'), findsOneWidget);

      _sessionBloc.allowedRbacs = {ApplicationRbac.morarIaBella};
      harness.circuitBreaker.ruleStream.add([]);
      await tester.pumpAndSettle();
      expect(find.text('hi, Ana'), findsOneWidget);
      expect(find.byType(UnityPage), findsNothing);
    });

    testWidgets('foto e sino navegam', (tester) async {
      await pumpNav(tester);
      tester.widget<HomeAppBar>(find.byType(HomeAppBar)).pictureOnTap();
      await tester.pumpAndSettle();
      expect(observer.pushedNames.last, ApplicationRoute.me);
      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await tester.pumpAndSettle();

      await tester.tap(findSvg('assets/notification-icon.svg'));
      await tester.pumpAndSettle();
      expect(find.byType(NotificationListPage), findsOneWidget);
      expect(fakeAnalytics.eventNames, contains('notificacoes_acessar'));

      final page = tester.widget<NotificationListPage>(
          find.byType(NotificationListPage));
      expect(page.checkRbac, isTrue);
      expect(() => page.scopeLabelBuilder!(SingleNotification(id: '1')),
          returnsNormally);

      // Toque em uma notificação da lista redireciona.
      page.onTap(SingleNotification(
        id: '2',
        reference: 'ctx-u1',
        redirectPath: 'BOLETOS',
      ));
      await settleWithFrame(tester);
      expect(findRoute(ApplicationRoute.billets), findsOneWidget);
      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await tester.pumpAndSettle();

      page.onConfigurationTap!();
      await tester.pumpAndSettle();
      tester.takeException();
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    });

    testWidgets('home page navega para a aba de comodidades e para o perfil',
        (tester) async {
      await pumpNav(tester);
      final home = tester.widget<HomePage>(find.byType(HomePage));
      home.pictureOnTap();
      await tester.pumpAndSettle();
      expect(observer.pushedNames.last, ApplicationRoute.me);
      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await tester.pumpAndSettle();

      // Sem a aba de comodidades o salto é ignorado.
      home.onNavigateToComodidades!();
      await tester.pumpAndSettle();
      expect(find.text('hi, Ana'), findsOneWidget);
    });
  });

  group('redirecionamento por notificação', () {
    testWidgets('rota conhecida da unidade atual abre a tela', (tester) async {
      await pumpNav(tester, args: HomeNavigationPageArgs(redirectRoute: _redirect()));
      expect(findRoute(ApplicationRoute.billets), findsOneWidget);
      final args = observer.pushed.last.settings.arguments as BilletsPageArgs;
      expect(args.billetsNotificationContext, 'obj');
    });

    testWidgets('inApp ou sem contexto abre as notificações não lidas',
        (tester) async {
      await pumpNav(tester,
          args: HomeNavigationPageArgs(redirectRoute: _redirect(inApp: true)));
      expect(find.byType(NotificationListPage), findsOneWidget);
      expect(fakeAnalytics.eventNames, contains('notificacoes_acessar'));

      await tester.pumpWidget(const SizedBox());
      await pumpNav(tester,
          args: HomeNavigationPageArgs(redirectRoute: _redirect(context: null)));
      expect(find.byType(NotificationListPage), findsOneWidget);
    });

    testWidgets('contexto de outra unidade pede troca e redireciona depois',
        (tester) async {
      _sessionBloc.session = _sessaoDuasUnidades();
      final redirect = _redirect(context: 'ctx-u2');
      await pumpNav(tester,
          args: HomeNavigationPageArgs(redirectRoute: redirect));
      expect(find.byType(SwitchRoleAlertDialogWidget), findsOneWidget);

      await tester.tap(find.text('ME LEVE'));
      await tester.pumpAndSettle();
      expect(find.byType(SwitchRoleAlertDialogWidget), findsNothing);
      expect(_sessionBloc.selectedUnits.single.id, 'u2');

      // A sessão carregada com a nova unidade dispara o redirecionamento.
      _sessionBloc.emit(SessionLoadedState(_sessionBloc.session));
      await tester.pumpAndSettle();
      expect(findRoute(ApplicationRoute.billets), findsOneWidget);
      expect(redirect.didRedirect, isTrue);
    });

    testWidgets('contexto desconhecido não faz nada', (tester) async {
      await pumpNav(tester,
          args: HomeNavigationPageArgs(
              redirectRoute: _redirect(context: 'ctx-inexistente')));
      expect(find.byType(SwitchRoleAlertDialogWidget), findsNothing);
      expect(findRoute(ApplicationRoute.billets), findsNothing);
    });

    testWidgets('comodidades pula para a aba quando ela existe',
        (tester) async {
      _sessionBloc.allowedRbacs = null;
      harness.http.on('GET', '/condominiums/c1/comfort/v2', body: []);
      await pumpNav(tester,
          args: HomeNavigationPageArgs(redirectRoute: _redirect(rote: 'COMODIDADES')),
          settle: false);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(ComoditiesPage), findsOneWidget);
      expect(find.byType(HomePage), findsNothing);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('rota sem tratamento cai na rota nomeada do app',
        (tester) async {
      final known = LelloApp.routes.keys
          .firstWhere((k) => k == ApplicationRoute.mailing);
      await pumpNav(tester,
          args: HomeNavigationPageArgs(redirectRoute: _redirect(rote: known)));
      expect(findRoute(ApplicationRoute.mailing), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await pumpNav(tester,
          args: HomeNavigationPageArgs(
              redirectRoute: _redirect(rote: 'ROTA_INEXISTENTE')));
      expect(observer.pushedNames.last, pageRouteName);
    });

    testWidgets('sem rbac para a rota nada acontece', (tester) async {
      _sessionBloc.allowedRbacs = {ApplicationRbac.morarIaBella};
      await pumpNav(tester, args: HomeNavigationPageArgs(redirectRoute: _redirect()));
      expect(findRoute(ApplicationRoute.billets), findsNothing);
    });

    testWidgets('mesmo redirecionamento não é processado duas vezes',
        (tester) async {
      final redirect = _redirect();
      await pumpNav(tester, args: HomeNavigationPageArgs(redirectRoute: redirect));
      expect(findRoute(ApplicationRoute.billets), findsOneWidget);
      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await tester.pumpAndSettle();

      _sessionBloc.emit(SessionLoadedState(_sessionBloc.session));
      await tester.pumpAndSettle();
      expect(findRoute(ApplicationRoute.billets), findsNothing);
      expect(observer.pushedNames.where((n) => n == ApplicationRoute.billets),
          hasLength(1));
    });

    testWidgets('toque em uma notificação redireciona conforme a unidade',
        (tester) async {
      _sessionBloc.session = _sessaoDuasUnidades();
      await pumpNav(tester);
      final state = navState(tester);

      // Sem caminho não faz nada.
      state.notificationDetailRedirect(SingleNotification(id: '1'));
      await settleWithFrame(tester);
      expect(observer.pushedNames.last, pageRouteName);

      // Unidade atual: abre direto.
      state.notificationDetailRedirect(SingleNotification(
        id: '2',
        reference: 'ctx-u1',
        redirectPath: 'BOLETOS',
        redirectId: 'b2',
      ));
      await settleWithFrame(tester);
      expect(findRoute(ApplicationRoute.billets), findsOneWidget);
      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await settleWithFrame(tester);

      // Unidade desconhecida: também abre direto.
      state.notificationDetailRedirect(SingleNotification(
        id: '3',
        reference: 'ctx-zzz',
        redirectPath: 'CORRESPONDENCIAS_ENTRADA',
        uuidGroup: 'g',
      ));
      await settleWithFrame(tester);
      expect(findRoute(ApplicationRoute.mailing), findsOneWidget);
      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await settleWithFrame(tester);

      // Outra unidade conhecida: reabre a home com os argumentos.
      state.notificationDetailRedirect(SingleNotification(
        id: '4',
        reference: 'ctx-u2',
        redirectPath: 'BOLETOS',
      ));
      await settleWithFrame(tester);
      expect(findRoute(SharedApplicationRoute.home), findsOneWidget);
      final args =
          observer.pushed.last.settings.arguments as HomeNavigationPageArgs;
      expect(args.redirectRoute?.context, 'ctx-u2');
    });

    testWidgets('push que abriu o app encerrado é redirecionado',
        (tester) async {
      await pumpNav(tester);
      final messaging =
          FirebaseMessagingPlatform.instance as FakeMessagingPlatform;
      messaging.initialMessage = const RemoteMessage(data: {
        'id': '9',
        'reference': 'ctx-u1',
        'redirectPath': 'BOLETOS',
        'redirectId': 'b9',
        'uuidGroup': 'g9',
      });
      navState(tester).myBackgroundMessageHandler();
      await settleWithFrame(tester);
      expect(findRoute(ApplicationRoute.billets), findsOneWidget);

      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await settleWithFrame(tester);
      messaging.initialMessage = const RemoteMessage(data: {'id': '10'});
      navState(tester).myBackgroundMessageHandler();
      await settleWithFrame(tester);
      expect(findRoute(ApplicationRoute.billets), findsNothing);
      messaging.initialMessage = null;
    });
  });

  group('sessão', () {
    testWidgets('estados de carregamento mostram o aviso', (tester) async {
      await pumpNav(tester);
      // O primeiro pump só entrega o evento (microtask); o segundo desenha.
      _sessionBloc.emit(SessionLoadingState(_sessionBloc.session));
      await tester.pump();
      await tester.pump();
      expect(find.text('home_page_fetching_profile'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(HomePage), findsNothing);

      _sessionBloc.emit(const SessionInitialState());
      await tester.pump();
      await tester.pump();
      expect(find.text('home_page_fetching_profile'), findsOneWidget);

      _sessionBloc.emit(SessionLoadedState(_sessionBloc.session));
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
      expect(
        harness.http.requests.map((r) => r.url.path),
        contains('/dashboard/register_fcm_token'),
      );
    });

    testWidgets('falha de troca de unidade mostra o aviso', (tester) async {
      await pumpNav(tester);
      _sessionBloc.emit(
          SessionLoadedState(_sessionBloc.session, switchFailed: true));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(Flushbar), findsOneWidget);
      expect(find.text('error_switch_role'), findsOneWidget);
      // O Flushbar mantém um timer de 5s: desmontamos a árvore e deixamos o
      // timer disparar sem tela.
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 6));
    });

    testWidgets('sessão expirada leva para a tela de sessão expirada',
        (tester) async {
      await pumpNav(tester);
      _sessionBloc.emit(SessionFailedState(KnownFailure('COD', 'err'), testMe()));
      await tester.pumpAndSettle();
      expect(findRoute(SharedApplicationRoute.expiredSession), findsOneWidget);
      expect(_sessionBloc.emptyStateCalls, greaterThan(0));
      final args = observer.pushed.last.settings.arguments
          as ExpiredSessionArguments;
      expect(args.reason, 'COD');
      expect(args.cpf, '12345678901');
      expect(args.accessToken, 'acc');
    });

    testWidgets('sessão expirada sem usuário e sem token usa os padrões',
        (tester) async {
      await harness.override<GetToken>(FakeGetToken(fail: true));
      await pumpNav(tester);
      _sessionBloc.emit(SessionFailedState(UnknownFailure('x'), null));
      await tester.pumpAndSettle();
      final args = observer.pushed.last.settings.arguments
          as ExpiredSessionArguments;
      expect(args.reason, 'Sessão expirada generico');
      expect(args.cpf, 'noCPF');
      expect(args.accessToken, 'noToken');
      expect(args.refreshToken, 'noRefresh');
    });
  });

  group('tema e ciclo de vida', () {
    testWidgets('app genérico aplica o tema do condomínio', (tester) async {
      _sessionBloc.session =
          testSession(condominium: testCondominium(layout: testLayout()));
      final themes = <ThemeData>[];
      await pumpNav(tester, isGeneric: true, changeTheme: themes.add);
      expect(themes, hasLength(1));
      expect(themes.single.brightness, Brightness.light);

      _sessionBloc.updateThemeColor(
          ThemeColorValue(Colors.blue, Colors.green, true));
      navState(tester).changeTheme(SessionLoadedState(_sessionBloc.session));
      expect(themes, hasLength(2));
      expect(themes.last.brightness, Brightness.dark);
    });

    testWidgets('sem layout ou sem callback o tema não muda', (tester) async {
      final themes = <ThemeData>[];
      await pumpNav(tester, isGeneric: true, changeTheme: themes.add);
      expect(themes, isEmpty);

      _sessionBloc.session =
          testSession(condominium: testCondominium(layout: testLayout()));
      navState(tester).changeTheme(SessionLoadedState(_sessionBloc.session));
      expect(themes, hasLength(1));

      await tester.pumpWidget(const SizedBox());
      await pumpNav(tester, isGeneric: true);
      navState(tester).changeTheme(SessionLoadedState(_sessionBloc.session));
      expect(themes, hasLength(1));
    });

    testWidgets('ao voltar do background processa a ghost notification',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        'PREFERENCES_HOME_CARDS_ONBOARDING12345678901': '{"onboarding": true}',
        SharedPreferencesKeys.ghostNotificationLogout:
            json.encode({'id': 'g1', 'type': 'LOGOUT'}),
      });
      await pumpNav(tester);
      final binding = tester.binding;
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
      await tester.pumpAndSettle();
      expect(platformCalls.map((c) => c.method), contains('onResume'));
      expect(platformCalls.map((c) => c.method), contains('onPause'));
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(SharedPreferencesKeys.ghostNotificationLogout), '');

      // Sem ghost notification pendente nada é enviado.
      await navState(tester).verifyLogoutGhostNotification();
      binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
    });
  });
}
