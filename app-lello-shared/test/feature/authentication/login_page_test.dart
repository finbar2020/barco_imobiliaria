import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:shared_features/feature/authentication/data/data_source/remote/authentication_api.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../helpers/fake_url_launcher.dart';
import '../../helpers/firebase_mocks.dart';
import '../../helpers/pump_app.dart';
import 'authentication_support.dart';

void main() {
  late AuthenticationHarness harness;
  late RecordingNavigatorObserver observer;
  late FakeUrlLauncherPlatform launcher;

  setUp(() async {
    await setUpFakeFirebase();
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'Lello',
      packageName: 'br.com.lello.morar',
      version: '9.9.9',
      buildNumber: '1',
      buildSignature: '',
    );
    launcher = installFakeUrlLauncher();
    harness = AuthenticationHarness();
    harness.container.register<Environment>(TestEnvironment());
    observer = RecordingNavigatorObserver();
  });

  Future<void> pumpLogin(
    WidgetTester tester, {
    AppOriginEnum origin = AppOriginEnum.owner,
    Object? arguments,
    bool settle = true,
  }) async {
    harness.container
        .registerLazy<AuthenticationStore>(() => harness.buildStore());
    await pumpPage(
      tester,
      LoginPage(appContainer: harness.container, appOriginEnum: origin),
      arguments: arguments,
      observer: observer,
      settle: settle,
    );
  }

  Future<void> fillAndSubmit(WidgetTester tester) async {
    await tester.enterText(find.byType(TextFormField).at(0), '52998224725');
    await tester.enterText(find.byType(TextFormField).at(1), 'senha');
    await tester.tap(find.widgetWithText(ElevatedButton, 'login'));
    await tester.pump();
  }

  testWidgets('mostra o formulário de login do morador', (tester) async {
    await pumpLogin(tester);

    expect(find.text('login'), findsNWidgets(2));
    expect(find.text('login_title'), findsOneWidget);
    expect(find.text('email/cnpj'), findsOneWidget);
    expect(find.text('password'), findsOneWidget);
    expect(find.text('still_not_registered'), findsOneWidget);
    expect(find.text('sign_up'), findsOneWidget);
    expect(find.text('forgot_password'), findsOneWidget);
    expect(find.text('login_form_register_fixed_point'), findsNothing);
    expect(find.textContaining('9.9.9'), findsOneWidget);

    await expectLater(
      find.byType(LoginPage),
      matchesGoldenFile('goldens/login_page.png'),
    );
  });

  testWidgets('login com sucesso vai para a home', (tester) async {
    harness.mockToken();
    await pumpLogin(tester);

    await fillAndSubmit(tester);
    await tester.pumpAndSettle();

    expect(harness.requestedPaths, ['/tokenrbac']);
    expect(harness.http.requests.single.body, contains('52998224725'));
    expect(harness.firebase.tokens, ['fb-1']);
    expect(findRoute(SharedApplicationRoute.home), findsOneWidget);
    expect(find.byType(LoginPage), findsNothing);
  });

  testWidgets('credenciais inválidas mostram o erro e o link do Resolva Fácil',
      (tester) async {
    harness.mockToken(
        status: 401,
        body: apiFailureBody(
            status: 401,
            failure: AuthenticationApi.invalid_credentials_failure));
    await pumpLogin(tester);

    await fillAndSubmit(tester);
    await tester.pumpAndSettle();

    expect(find.text('error_invalid_credentials'), findsOneWidget);
    expect(find.text('send_message_resolva_facil'), findsOneWidget);

    await tester.tap(find.text('send_message_resolva_facil'));
    await tester.pumpAndSettle();

    expect(launcher.launched.single, contains('wa.me/551127977585'));
    expect(launcher.launched.single, contains('resolva_facil_message'));
  });

  testWidgets('erro desconhecido no síndico não mostra o Resolva Fácil',
      (tester) async {
    harness.mockToken(status: 500, body: apiFailureBody());
    await pumpLogin(tester, origin: AppOriginEnum.manager);

    await fillAndSubmit(tester);
    await tester.pumpAndSettle();

    expect(find.text('error_unknown'), findsOneWidget);
    expect(find.text('send_message_resolva_facil'), findsNothing);
  });

  testWidgets('enquanto autentica os links ficam desabilitados',
      (tester) async {
    await pumpLogin(tester);
    final store = harness.lastStore!;
    // ignore: invalid_use_of_visible_for_testing_member
    store.bloc.emit(const AuthenticatingState());
    await tester.pump();
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.text('sign_up'));
    await tester.tap(find.text('forgot_password'));
    await tester.pump();

    expect(observer.pushedNames, isNot(contains(SharedApplicationRoute.registration)));
    expect(observer.pushedNames, isNot(contains(SharedApplicationRoute.resetPassword)));
    final username = tester.widget<TextFormField>(find.byType(TextFormField).first);
    expect(username.enabled, isFalse);
  });

  testWidgets('cadastrar e esqueci a senha navegam com o container',
      (tester) async {
    await pumpLogin(tester);

    await tester.tap(find.text('sign_up'));
    await tester.pumpAndSettle();
    expect(findRoute(SharedApplicationRoute.registration), findsOneWidget);
    expect(observer.pushed.last.settings.arguments, same(harness.container));

    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle();

    await tester.tap(find.text('forgot_password'));
    await tester.pumpAndSettle();
    expect(findRoute(SharedApplicationRoute.resetPassword), findsOneWidget);
    expect(observer.pushed.last.settings.arguments, same(harness.container));
    expect(fakeAnalytics.eventNames, isNotEmpty);
  });

  testWidgets('esqueci a senha no síndico registra o evento do síndico',
      (tester) async {
    fakeAnalytics.reset();
    await pumpLogin(tester, origin: AppOriginEnum.manager);

    await tester.tap(find.text('forgot_password'));
    await tester.pumpAndSettle();

    expect(findRoute(SharedApplicationRoute.resetPassword), findsOneWidget);
    expect(fakeAnalytics.eventNames, isNotEmpty);
  });

  testWidgets('argumento de cadastro mostra o carregamento e abre o cadastro',
      (tester) async {
    await pumpLogin(tester,
        arguments: AuthArguments(goToRegister: true), settle: false);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();

    expect(findRoute(SharedApplicationRoute.registration), findsOneWidget);
    expect(observer.pushedNames.where((n) => n == SharedApplicationRoute.registration),
        hasLength(1));
  });

  testWidgets('argumento sem cadastro mostra o formulário normal',
      (tester) async {
    await pumpLogin(tester, arguments: AuthArguments(goToRegister: false));
    expect(find.text('login_title'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('alterna a visibilidade da senha e envia pelo teclado',
      (tester) async {
    harness.mockToken();
    await pumpLogin(tester);

    expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pump();
    expect(find.byIcon(Icons.visibility), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), '52998224725');
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pump();
    await tester.enterText(find.byType(TextFormField).at(1), 'senha');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(harness.requestedPaths, ['/tokenrbac']);
    expect(findRoute(SharedApplicationRoute.home), findsOneWidget);
  });

  testWidgets('voltar cancela o preenchimento automático', (tester) async {
    await pumpLogin(tester);

    // O `pumpPage` gera uma rota "/" abaixo da página: o WillPopScope libera
    // o pop e a tela de login sai.
    await tester.state<NavigatorState>(find.byType(Navigator)).maybePop();
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsNothing);
    expect(findRoute('/'), findsOneWidget);
  });

  testWidgets('app genérico usa o tema viver', (tester) async {
    PackageInfo.setMockInitialValues(
      appName: 'Viver',
      packageName: SharedPreferencesKeys.genericMorar,
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
    await pumpLogin(tester);

    final theme = Theme.of(tester.element(find.byType(LoginForm)));
    expect(theme.primaryColor, LelloTheme.viverDefaultTheme.primaryColor);
  });

  group('colaborador', () {
    setUp(() => initHiveTemp());

    /// As caixas do Hive são abertas (IO real) fora do fake async; depois
    /// disso `Hive.openBox` devolve a caixa já aberta e `get`/`containsKey`
    /// são síncronos, então a tela pode ser bombeada normalmente.
    Future<void> openTabletBoxes(WidgetTester tester, {String? condoCode}) =>
        tester.runAsync(() async {
          await Hive.openBox(SharedPreferencesKeys.isTabletSession);
          await Hive.openBox(SharedPreferencesKeys.sessionStartDate);
          if (condoCode != null) await TabletSessionUtils.setCondoCode(condoCode);
        });

    testWidgets('mostra o link do ponto fixo e vai para o login do tablet',
        (tester) async {
      await openTabletBoxes(tester);
      await pumpLogin(tester, origin: AppOriginEnum.employee);

      expect(find.text('email'), findsOneWidget);
      expect(find.text('login_form_register_fixed_point'), findsOneWidget);

      await tester.tap(find.text('login_form_register_fixed_point'));
      await tester.pumpAndSettle();

      expect(findRoute(SharedApplicationRoute.loginTablet), findsOneWidget);
      expect(find.byType(LoginPage), findsNothing);
    });

    testWidgets('com código do condomínio salvo redireciona para o tablet',
        (tester) async {
      await openTabletBoxes(tester, condoCode: 'C1');
      await pumpLogin(tester, origin: AppOriginEnum.employee);

      expect(findRoute(SharedApplicationRoute.loginTablet), findsOneWidget);
      expect(observer.pushed.last.settings.arguments, 'C1');
    });

    testWidgets('esqueci a senha no colaborador registra o evento',
        (tester) async {
      fakeAnalytics.reset();
      await openTabletBoxes(tester);
      await pumpLogin(tester, origin: AppOriginEnum.employee);

      await tester.ensureVisible(find.text('forgot_password'));
      await tester.tap(find.text('forgot_password'));
      await tester.pumpAndSettle();

      expect(findRoute(SharedApplicationRoute.resetPassword), findsOneWidget);
      expect(fakeAnalytics.eventNames, isNotEmpty);
    });

    testWidgets('login do colaborador consulta a sessão de tablet',
        (tester) async {
      harness.mockToken();
      await openTabletBoxes(tester);
      await pumpLogin(tester, origin: AppOriginEnum.employee);

      await fillAndSubmit(tester);
      await tester.pumpAndSettle();

      expect(harness.lastStore!.isTabletSession, isFalse);
      expect(harness.requestedPaths, ['/tokenrbac']);
      expect(findRoute(SharedApplicationRoute.home), findsOneWidget);
    });
  });
}
