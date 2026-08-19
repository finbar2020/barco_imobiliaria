import 'package:colaborador/core/app_connectivity/app_connectivity.dart';
import 'package:colaborador/core/bloc/inactivity/inactivity_cubit.dart';
import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/condo_info.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/condominium_code_info.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/employee_info.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_condominium_step_widget.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_employees_step_widget.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_list_offile_points_widget.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_loaded_widget.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_login_step_widget.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_offline_save_point_widget.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

class _FakeConnectivity extends Fake implements AppConnectivity {
  _FakeConnectivity({this.online = true});

  final bool online;

  @override
  Future<bool> checkConnectivity() async => online;
}

class _FakeSessionBloc extends Fake implements SessionBloc {
  @override
  String getBaseUrl() => 'http://localhost';

  @override
  bool showButtonNoAuthPointList(String reference) => false;
}

class _FakeAuthenticationStore extends Fake implements AuthenticationStore {
  _FakeAuthenticationStore(this.bloc);

  @override
  final AuthenticationBloc bloc;

  @override
  Map<String, String>? getCustomHeader() => null;
}

class _FakeInactivityCubit extends Fake implements InactivityCubit {
  @override
  void start() {}
}

late AuthenticationBloc _authenticationBloc;
late TestTabletAuthScope _tabletScope;

final _employee = EmployeeInfo(
  numCra: '1',
  numCad: '2',
  cpf: '12345678901',
  name: 'ANA SILVA',
  jobPosition: 'PORTEIRO',
  idLogin: 'l1',
  pictureHash: '',
  registered: true,
  statusEnum: DigitalTimesheetStatusEnum.approved,
);

final _condoInfo = CondominiumCodeInfo(
  condoCode: 'ABC123',
  condominium: CondoInfo(
    reference: 'R1',
    name: 'torre lello',
    picturehash: '',
    status: 'active',
    ref: 'R1',
  ),
  employees: [_employee],
);

Future<void> _installContainer({bool online = true}) async {
  _tabletScope = await installTestTabletAuth();
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.unregister<Environment>();
  }
  _authenticationBloc = AuthenticationBloc();

  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<SessionBloc>(_FakeSessionBloc());
  locator.registerSingleton<AppConnectivity>(_FakeConnectivity(online: online));
  locator.registerSingleton<AuthenticationStore>(
    _FakeAuthenticationStore(_authenticationBloc),
  );
  locator.registerSingleton<InactivityCubit>(_FakeInactivityCubit());
}

Future<void> _pumpLoaded(WidgetTester tester) async {
  await pumpApp(
    tester,
    LoginTabletLoadedWidget(condominiumCodeInfo: _condoInfo),
    localized: true,
    shrinkWrap: false,
    settle: false,
    surface: const Size(700, 1000),
  );
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

Future<void> _goToEmployees(WidgetTester tester) async {
  await tester.tap(find.text('login_tablet_condo_start'));
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  tearDown(() async {
    _tabletScope.dispose();
    await _authenticationBloc.close();
    await resetTestApplicationContainer();
  });

  group('LoginTabletLoadedWidget', () {
    testWidgets('começa no passo do condomínio', (tester) async {
      await _installContainer();
      await _pumpLoaded(tester);

      expect(find.byType(LoginTabletCondominiumStepWidget), findsOneWidget);
      expect(find.text('TORRE LELLO'), findsOneWidget);
    });

    testWidgets('iniciar avança para a lista de colaboradores', (tester) async {
      await _installContainer();
      await _pumpLoaded(tester);

      await _goToEmployees(tester);

      expect(find.byType(LoginTabletEmployeesStepWidget), findsOneWidget);
      expect(find.text('Ana Silva'), findsOneWidget);
    });

    testWidgets('online o colaborador escolhido vai para o login',
        (tester) async {
      await _installContainer();
      await _pumpLoaded(tester);
      await _goToEmployees(tester);

      await tester.tap(find.text('Ana Silva'));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(find.byType(LoginTabletLoginStepWidget), findsOneWidget);
    });

    testWidgets('offline o colaborador escolhido vai para o ponto offline',
        (tester) async {
      await _installContainer(online: false);
      await _pumpLoaded(tester);
      await _goToEmployees(tester);

      await tester.tap(find.text('Ana Silva'));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(
        find.byType(LoginTabletLoginOfflineSavePointWidget),
        findsOneWidget,
      );
    });

    testWidgets('voltar do login retorna para a lista', (tester) async {
      await _installContainer();
      await _pumpLoaded(tester);
      await _goToEmployees(tester);
      await tester.tap(find.text('Ana Silva'));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      await tester.tap(find.byIcon(Icons.arrow_back_ios_rounded));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(find.byType(LoginTabletEmployeesStepWidget), findsOneWidget);
    });

    testWidgets('abre a lista de pontos offline pendentes', (tester) async {
      await _installContainer();
      await _pumpLoaded(tester);

      final state = tester.state<State<LoginTabletLoadedWidget>>(
        find.byType(LoginTabletLoadedWidget),
      );
      // ignore: avoid_dynamic_calls
      (state as dynamic).currentStep = LoginTabletSteps.listOfflinePoints;
      // ignore: invalid_use_of_protected_member
      state.setState(() {});
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(find.byType(LoginTabletListOfflinePoints), findsOneWidget);
    });
  });
}
