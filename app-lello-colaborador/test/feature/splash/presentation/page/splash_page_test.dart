import 'package:colaborador/core/bloc/inactivity/inactivity_cubit.dart';
import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/splash/presentation/page/splash_page.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

class _FakeAuthenticationBloc extends Fake implements AuthenticationBloc {
  _FakeAuthenticationBloc(this.state);

  @override
  final AuthenticationState state;
}

class _FakeInactivityCubit extends Fake implements InactivityCubit {
  bool started = false;

  @override
  void start() => started = true;
}

late _FakeInactivityCubit _inactivityCubit;

Future<void> _installContainer({required bool authenticated}) async {
  SharedPreferences.setMockInitialValues({});
  PackageInfo.setMockInitialValues(
    appName: 'colaborador',
    packageName: 'br.com.lello.colaborador',
    version: '9.9.9',
    buildNumber: '1',
    buildSignature: '',
  );

  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  _inactivityCubit = _FakeInactivityCubit();

  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<InactivityCubit>(_inactivityCubit);
  locator.registerSingleton<AuthenticationBloc>(
    _FakeAuthenticationBloc(
      authenticated
          ? AuthenticatedState(accessToken: AccessToken()..accessToken = 't')
          : const UnauthenticatedState(),
    ),
  );
}

Future<List<String>> _pumpSplash(WidgetTester tester) async {
  final routes = <String>[];
  await pumpApp(
    tester,
    Navigator(
      onGenerateRoute: (settings) {
        routes.add(settings.name ?? '');
        return MaterialPageRoute(
          builder: (_) => settings.name == null ||
                  settings.name == Navigator.defaultRouteName
              ? const SplashPage()
              : const SizedBox(),
        );
      },
    ),
    localized: true,
    wrapInScaffold: false,
    shrinkWrap: false,
    settle: false,
    surface: const Size(400, 800),
  );
  await tester.pump();
  return routes;
}

void main() {
  tearDown(resetTestApplicationContainer);

  group('SplashPage', () {
    testWidgets('exibe identidade do app e a versão instalada', (tester) async {
      await _installContainer(authenticated: false);
      final routes = await _pumpSplash(tester);
      await tester.pump();

      expect(find.text('App para Colaboradores'), findsOneWidget);
      expect(find.text('versão 9.9.9'), findsOneWidget);
      expect(routes, [Navigator.defaultRouteName]);

      // Consome o timer do splash para o teste não terminar com timer pendente.
      await tester.pump(const Duration(seconds: 4));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
    });

    testWidgets('sem sessão vai para o login depois do splash', (tester) async {
      await _installContainer(authenticated: false);
      final routes = await _pumpSplash(tester);

      await tester.pump(const Duration(seconds: 4));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(routes, contains(SharedApplicationRoute.login));
      expect(_inactivityCubit.started, isFalse);
    });

    testWidgets('com sessão vai para a home e liga o timer de inatividade',
        (tester) async {
      await _installContainer(authenticated: true);
      final routes = await _pumpSplash(tester);

      await tester.pump(const Duration(seconds: 4));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(routes, contains(SharedApplicationRoute.home));
      expect(_inactivityCubit.started, isTrue);
    });
  });
}
