import 'package:colaborador/core/bloc/inactivity/inactivity_cubit.dart';
import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/employee_info.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_loaded_widget.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_offline_save_point_widget.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart' hide isNotNull, isNull;
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

class _FakeAuthenticationStore extends Fake implements AuthenticationStore {
  _FakeAuthenticationStore(this.bloc);

  @override
  final AuthenticationBloc bloc;

  @override
  Map<String, String>? getCustomHeader() => null;
}

late AuthenticationBloc _authenticationBloc;

Future<void> _installContainer() async {
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  final sessionBloc = _FakeSessionBloc();
  _authenticationBloc = AuthenticationBloc();

  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<SessionBloc>(sessionBloc);
  locator.registerSingleton<AuthenticationStore>(
    _FakeAuthenticationStore(_authenticationBloc),
  );
  locator.registerSingleton<InactivityCubit>(
    InactivityCubit(sessionBloc: sessionBloc),
  );
}

EmployeeInfo _employee({
  DigitalTimesheetStatusEnum status = DigitalTimesheetStatusEnum.approved,
}) =>
    EmployeeInfo(
      numCra: '1',
      numCad: '2',
      cpf: '12345678901',
      name: 'ANA SILVA',
      jobPosition: 'PORTEIRO',
      idLogin: 'l1',
      pictureHash: '',
      registered: true,
      statusEnum: status,
    );

Future<List<LoginTabletSteps>> _pumpWidget(
  WidgetTester tester, {
  DigitalTimesheetStatusEnum status = DigitalTimesheetStatusEnum.approved,
}) async {
  final steps = <LoginTabletSteps>[];
  await pumpApp(
    tester,
    LoginTabletLoginOfflineSavePointWidget(
      employee: _employee(status: status),
      condoRef: 'R1',
      changeStep: steps.add,
    ),
    localized: true,
    shrinkWrap: false,
    surface: const Size(600, 1000),
  );
  return steps;
}

void main() {
  setUp(_installContainer);
  tearDown(() async {
    await _authenticationBloc.close();
    await resetTestApplicationContainer();
  });

  group('LoginTabletLoginOfflineSavePointWidget', () {
    testWidgets('exibe aviso de registro offline e dados do colaborador',
        (tester) async {
      await _pumpWidget(tester);

      expect(find.text('register_tablet_offline'), findsOneWidget);
      expect(find.text('register_tablet_offline_subtitle'), findsOneWidget);
      expect(find.text('register_tablet_offline_info'), findsOneWidget);
      expect(find.text('Ana Silva'), findsOneWidget);
      expect(
        find.text(LgpdFormatter.formatCpf('12345678901')),
        findsOneWidget,
      );
    });

    testWidgets('mantém o botão desabilitado enquanto os termos não são aceitos',
        (tester) async {
      await _pumpWidget(tester);

      final button = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('habilita o botão ao aceitar os termos', (tester) async {
      await _pumpWidget(tester);

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);
      final button = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('desmarcar os termos desabilita o botão novamente',
        (tester) async {
      await _pumpWidget(tester);

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isFalse);
      expect(
        tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNull,
      );
    });

    testWidgets('sem biometria cadastrada não oferece registro offline',
        (tester) async {
      await _pumpWidget(tester, status: DigitalTimesheetStatusEnum.pending);

      expect(find.text('register_tablet_offline_no_photo'), findsOneWidget);
      expect(find.byType(Checkbox), findsNothing);
      expect(find.byType(PrimaryButton), findsNothing);
    });

    testWidgets('voltar retorna para a lista de colaboradores', (tester) async {
      final steps = await _pumpWidget(tester);

      await tester.tap(find.byIcon(Icons.arrow_back_ios_rounded));
      await tester.pumpAndSettle();

      expect(steps, [LoginTabletSteps.employees]);
    });
  });
}
