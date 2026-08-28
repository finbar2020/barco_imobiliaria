import 'package:colaborador/core/bloc/inactivity/inactivity_cubit.dart';
import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/employee_info.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_loaded_widget.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_login_step_widget.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart' hide isNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

class _FakeSessionBloc extends Fake implements SessionBloc {
  @override
  String getBaseUrl() => 'http://localhost';
}

class _FakeInactivityCubit extends Fake implements InactivityCubit {
  bool started = false;

  @override
  void start() => started = true;
}

class _FakeAuthenticationStore extends Fake implements AuthenticationStore {
  _FakeAuthenticationStore(this.bloc);

  @override
  final AuthenticationBloc bloc;

  @override
  late Credentials credentials;

  bool authenticateCalled = false;

  @override
  Map<String, String>? getCustomHeader() => null;

  @override
  Future<void> authenticate() async => authenticateCalled = true;
}

late AuthenticationBloc _authenticationBloc;
late _FakeAuthenticationStore _store;
late _FakeInactivityCubit _inactivityCubit;

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

Future<void> _installContainer() async {
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  _authenticationBloc = AuthenticationBloc();
  _store = _FakeAuthenticationStore(_authenticationBloc);
  _inactivityCubit = _FakeInactivityCubit();

  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<SessionBloc>(_FakeSessionBloc());
  locator.registerSingleton<AuthenticationStore>(_store);
  locator.registerSingleton<InactivityCubit>(_inactivityCubit);
}

Future<List<LoginTabletSteps>> _pumpStep(WidgetTester tester) async {
  final steps = <LoginTabletSteps>[];
  await pumpApp(
    tester,
    LoginTabletLoginStepWidget(
      employee: _employee,
      changeStep: steps.add,
    ),
    localized: true,
    shrinkWrap: false,
    settle: false,
    surface: const Size(600, 1000),
  );
  await tester.pump();
  return steps;
}

void main() {
  setUp(_installContainer);
  tearDown(() async {
    await _authenticationBloc.close();
    await resetTestApplicationContainer();
  });

  group('LoginTabletLoginStepWidget', () {
    testWidgets('exibe o formulário de senha do colaborador', (tester) async {
      await _pumpStep(tester);

      expect(find.text('login_tablet_enter_password'), findsOneWidget);
      expect(find.text('Ana Silva'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('voltar retorna para a lista de colaboradores', (tester) async {
      final steps = await _pumpStep(tester);

      await tester.tap(find.byIcon(Icons.arrow_back_ios_rounded));
      await tester.pump();

      expect(steps, [LoginTabletSteps.employees]);
    });

    testWidgets('entrar autentica e liga o timer de inatividade',
        (tester) async {
      await _pumpStep(tester);

      await tester.enterText(find.byType(TextFormField), 'Senha@123');
      await tester.tap(find.text('login_tablet_sign_sign'));
      await tester.pump();

      expect(_store.authenticateCalled, isTrue);
      expect(_store.credentials.username, '12345678901');
      expect(_store.credentials.password, 'Senha@123');
      expect(_inactivityCubit.started, isTrue);
    });

    testWidgets('durante a autenticação exibe loading e bloqueia toques',
        (tester) async {
      // O estado precisa estar posto antes do primeiro build: o BlocConsumer
      // deste passo é montado com o estado corrente do bloc.
      _authenticationBloc.add(const AuthenticatingEvent());
      await _pumpStep(tester);

      expect(_authenticationBloc.state, isA<AuthenticatingState>());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('please_wait'), findsOneWidget);
      expect(
        tester
            .widgetList<IgnorePointer>(find.byType(IgnorePointer))
            .any((w) => w.ignoring),
        isTrue,
      );
    });

    testWidgets('falha de login mostra a mensagem de erro', (tester) async {
      _authenticationBloc.add(
        AuthenticationFailedEvent(error: KnownFailure('401', 'invalid')),
      );
      await _pumpStep(tester);

      expect(_authenticationBloc.state, isA<AuthenticationFailedState>());
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(_store.authenticateCalled, isFalse);
    });
  });
}
