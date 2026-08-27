import 'dart:convert';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/splash/presentation/page/splash_page.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/fake_local_auth.dart';
import '../../helpers/fake_url_launcher.dart';
import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';

void main() {
  late PageHarness harness;
  late FakeLocalAuthPlatform localAuth;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installPageHarness();
    localAuth = installFakeLocalAuth();
    observer = RecordingNavigatorObserver();
  });

  void bootData({required bool showOnBoarding}) {
    SharedPreferences.setMockInitialValues({
      SharedPreferencesKeys.ownerBootData:
          jsonEncode({'show_on_boarding': showOnBoarding}),
    });
  }

  void authenticated() {
    final authBloc = harness.resolve<AuthenticationBloc>();
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    authBloc.emit(
      AuthenticatedState(accessToken: AccessToken()..accessToken = 't'),
    );
  }

  Future<void> pumpSplash(WidgetTester tester) async {
    await pumpPage(tester, SplashPage(), observer: observer, settle: false);
    await tester.pump();
  }

  /// A cadeia boot data → remote config → timer de 3s precisa de vários
  /// pumps para se resolver antes de o timer ser criado.
  Future<void> drain(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
    await tester.pumpAndSettle();
  }

  testWidgets('mostra a marca e a versão e vai para o onboarding',
      (tester) async {
    await pumpSplash(tester);

    expect(find.text('Lello para Moradores'), findsOneWidget);
    expect(find.text('splash_subtitle'), findsOneWidget);
    expect(find.text('versão 9.9.9'), findsOneWidget);
    await expectLater(
      find.byType(SplashPage),
      matchesGoldenFile('goldens/splash_page.png'),
    );

    await drain(tester);

    expect(findRoute(ApplicationRoute.onBoarding), findsOneWidget);
  });

  testWidgets('sem onboarding e sem sessão vai para o login', (tester) async {
    bootData(showOnBoarding: false);
    await pumpSplash(tester);
    await drain(tester);

    expect(findRoute(SharedApplicationRoute.login), findsOneWidget);
    final args = observer.pushed.last.settings.arguments as AuthArguments;
    expect(args.goToRegister, isFalse);
  });

  testWidgets('com sessão e biometria aprovada vai para a home',
      (tester) async {
    bootData(showOnBoarding: false);
    authenticated();
    await pumpSplash(tester);
    await drain(tester);

    expect(localAuth.authenticateCalls, 1);
    expect(findRoute(SharedApplicationRoute.home), findsOneWidget);
  });

  testWidgets('aparelho sem biometria vai direto para a home', (tester) async {
    bootData(showOnBoarding: false);
    localAuth.supported = false;
    authenticated();
    await pumpSplash(tester);
    await drain(tester);

    expect(localAuth.authenticateCalls, 0);
    expect(findRoute(SharedApplicationRoute.home), findsOneWidget);
  });

  testWidgets('biometria ignorada nas preferências vai direto para a home',
      (tester) async {
    bootData(showOnBoarding: false);
    harness.sessionBloc.splashIgnoreBiometric = true;
    authenticated();
    await pumpSplash(tester);
    await drain(tester);

    expect(localAuth.authenticateCalls, 0);
    expect(findRoute(SharedApplicationRoute.home), findsOneWidget);
  });

  testWidgets('biometria recusada oferece tentar de novo e depois entra',
      (tester) async {
    bootData(showOnBoarding: false);
    localAuth.authenticateResult = false;
    authenticated();
    await pumpSplash(tester);
    await drain(tester);

    expect(find.text('splash_auth'), findsOneWidget);
    expect(find.byType(SplashPage), findsOneWidget);

    // Voltar do segundo plano com a autenticação pendente mantém o botão.
    final observerState =
        tester.state(find.byType(SplashPage)) as WidgetsBindingObserver;
    observerState.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await tester.pump();
    expect(find.text('splash_auth'), findsOneWidget);

    localAuth.authenticateResult = true;
    await tester.tap(find.text('splash_auth'));
    await drain(tester);

    expect(localAuth.authenticateCalls, 2);
    expect(findRoute(SharedApplicationRoute.home), findsOneWidget);
  });

  testWidgets('erro na biometria também oferece tentar de novo',
      (tester) async {
    bootData(showOnBoarding: false);
    localAuth.throwOnAuthenticate = true;
    authenticated();
    await pumpSplash(tester);
    await drain(tester);

    expect(find.text('splash_auth'), findsOneWidget);
  });

  /// O link da loja no iOS/macOS vem de uma consulta HTTP ao iTunes; o
  /// `http.get` é interceptado por zona com um cliente falso.
  Future<T> withStoreLookup<T>(Future<T> Function() body) =>
      http.runWithClient(
        body,
        () => MockClient((_) async => http.Response(
              jsonEncode({
                'results': [
                  {'trackViewUrl': 'https://apps.apple.com/br/app/morar'}
                ]
              }),
              200,
            )),
      );

  testWidgets('versão nova na loja mostra o diálogo de atualização',
      (tester) async {
    harness.remoteConfig.values = {
      'store_version': '{"storeVersion": "99.0.0"}',
      'force_update': '{"minVersion": "1.0.0"}',
    };
    await withStoreLookup(() async {
      await pumpSplash(tester);
      await drain(tester);
    });

    expect(find.text('new_version_app_title'), findsOneWidget);
    expect(find.text('new_version_app_dialog_text'), findsOneWidget);

    await tester.tap(find.text('no_update_app'));
    await tester.pumpAndSettle();

    expect(findRoute(ApplicationRoute.onBoarding), findsOneWidget);
  });

  testWidgets('atualização obrigatória abre a loja', (tester) async {
    final launcher = installFakeUrlLauncher();
    harness.remoteConfig.values = {
      'store_version': '{"storeVersion": "99.0.0"}',
      'force_update': '{"minVersion": "100.0.0"}',
    };
    await withStoreLookup(() async {
      await pumpSplash(tester);
      await drain(tester);
    });

    expect(find.text('new_version_app_title'), findsOneWidget);
    expect(find.text('new_version_app_critical_dialog_text'), findsOneWidget);

    await tester.tap(find.text('yes_update_app'));
    await tester.pumpAndSettle();

    expect(launcher.launched, contains('https://apps.apple.com/br/app/morar'));
    await drain(tester);
  });
}
