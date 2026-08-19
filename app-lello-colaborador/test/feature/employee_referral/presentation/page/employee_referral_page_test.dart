import 'dart:async';

import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/feature/employee_referral/domain/entity/city.dart';
import 'package:colaborador/feature/employee_referral/presentation/bloc/employee_referral_bloc.dart';
import 'package:colaborador/feature/employee_referral/presentation/bloc/employee_referral_state.dart';
import 'package:colaborador/feature/employee_referral/presentation/pages/employee_referral_page.dart';
import 'package:colaborador/feature/employee_referral/presentation/widgets/employee_referral_page_body_widget.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart' hide isNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

class _FakeRemoteConfig extends Fake implements FirebaseRemoteConfig {
  @override
  String getString(String key) => '10485760';
}

class _SessionBlocWithRemoteConfig extends FakeSessionBloc {
  @override
  FirebaseRemoteConfig? get remoteConfig => _FakeRemoteConfig();
}

class _FakeReferralBloc extends Fake implements EmployeeReferralBloc {
  _FakeReferralBloc(this._state);

  EmployeeReferralState _state;
  final _controller = StreamController<EmployeeReferralState>.broadcast();
  int citiesRequested = 0;

  @override
  List<CityEntity> cities = [
    CityEntity(name: 'Santos', regions: const []),
  ];

  @override
  EmployeeReferralState get state => _state;

  @override
  Stream<EmployeeReferralState> get stream => _controller.stream;

  @override
  void getCities() => citiesRequested++;

  @override
  Future<void> close() async {}

  void emitState(EmployeeReferralState state) {
    _state = state;
    _controller.add(state);
  }

  Future<void> dispose() => _controller.close();
}

late _FakeReferralBloc _bloc;

Future<void> _install(EmployeeReferralState state) async {
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  _bloc = _FakeReferralBloc(state);
  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<SessionBloc>(_SessionBlocWithRemoteConfig());
  locator.registerSingleton<EmployeeReferralBloc>(_bloc);
}

Future<List<String>> _pumpPage(WidgetTester tester) async {
  final routes = <String>[];
  await pumpApp(
    tester,
    Navigator(
      onGenerateRoute: (settings) {
        if (settings.name != null &&
            settings.name != Navigator.defaultRouteName) {
          routes.add(settings.name!);
        }
        return MaterialPageRoute(
          builder: (_) => settings.name == null ||
                  settings.name == Navigator.defaultRouteName
              ? const EmployeeReferralPage()
              : const SizedBox(),
        );
      },
    ),
    localized: true,
    wrapInScaffold: false,
    shrinkWrap: false,
    settle: false,
    surface: const Size(500, 1200),
  );
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  return routes;
}

void main() {
  tearDown(() async {
    await _bloc.dispose();
    await resetTestApplicationContainer();
  });

  group('EmployeeReferralPage', () {
    testWidgets('carregando cidades mostra o loading', (tester) async {
      await _install(const GetCitiesLoadingState());
      await _pumpPage(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(EmployeeReferralPageBodyWidget), findsNothing);
    });

    testWidgets('cidades carregadas montam o formulário', (tester) async {
      await _install(const GetCitiesLoadedState());
      await _pumpPage(tester);

      expect(find.byType(EmployeeReferralPageBodyWidget), findsOneWidget);
      expect(find.text('employee_referral_page_title'), findsOneWidget);
    });

    testWidgets('falha ao buscar cidades permite tentar novamente',
        (tester) async {
      await _install(
        const GetCitiesFailedState(errorCode: '500', errorDescription: 'erro'),
      );
      await _pumpPage(tester);

      expect(find.text('error_handling_widget_title'), findsOneWidget);

      await tester.tap(find.text('error_handling_widget_button_reTry'));
      await tester.pump();

      expect(_bloc.citiesRequested, 1);
    });

    testWidgets('envio concluído navega para a confirmação', (tester) async {
      await _install(const GetCitiesLoadedState());
      final routes = await _pumpPage(tester);

      _bloc.emitState(const EmployeeReferralRegisterLoadedState());
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(
        routes,
        contains(ApplicationRoute.employeeReferralRegisterSuccess),
      );
    });

    testWidgets('falha no envio navega para a tela de erro', (tester) async {
      await _install(const GetCitiesLoadedState());
      final routes = await _pumpPage(tester);

      _bloc.emitState(const EmployeeReferralRegisterFailedState());
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(routes, contains(ApplicationRoute.employeeReferralRegisterError));
    });

    testWidgets('abre mesmo sem remote config carregado', (tester) async {
      await _install(const GetCitiesLoadedState());
      final locator = ApplicationContainer.instance().locator;
      await locator.unregister<SessionBloc>();
      locator.registerSingleton<SessionBloc>(FakeSessionBloc());

      await _pumpPage(tester);

      expect(find.byType(EmployeeReferralPageBodyWidget), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
