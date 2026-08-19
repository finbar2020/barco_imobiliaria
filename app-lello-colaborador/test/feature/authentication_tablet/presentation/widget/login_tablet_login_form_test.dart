import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/employee_info.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_login_form_widget.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

class _FakeAuthenticationStore extends Fake implements AuthenticationStore {
  @override
  Map<String, String>? getCustomHeader() => null;
}

class _FakeSessionBloc extends Fake implements SessionBloc {
  @override
  String getBaseUrl() => 'http://localhost';
}

Future<void> _installContainer() async {
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<SessionBloc>(_FakeSessionBloc());
  locator.registerSingleton<AuthenticationStore>(_FakeAuthenticationStore());
}

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

Future<List<Credentials>> _pumpForm(
  WidgetTester tester, {
  String? errorMessage,
  TextEditingController? controller,
}) async {
  final credentials = <Credentials>[];
  await pumpApp(
    tester,
    LoginTabletLoginFormWidget(
      employee: _employee,
      passwordTextController: controller ?? TextEditingController(),
      loginFunction: credentials.add,
      errorMessage: errorMessage,
    ),
    localized: true,
    shrinkWrap: false,
    surface: const Size(600, 900),
  );
  return credentials;
}

void main() {
  setUp(_installContainer);
  tearDown(resetTestApplicationContainer);

  group('LoginTabletLoginFormWidget', () {
    testWidgets('exibe dados do colaborador e campo de senha', (tester) async {
      await _pumpForm(tester);

      expect(find.text('Ana Silva'), findsOneWidget);
      expect(find.text(LgpdFormatter.formatCpf('12345678901')), findsOneWidget);
      expect(find.text('password'), findsOneWidget);
      expect(find.text('type_password'), findsOneWidget);
      expect(find.text('forgot_password'), findsOneWidget);
      expect(find.text('login_tablet_sign_sign'), findsOneWidget);
    });

    testWidgets('senha começa oculta e alterna a visibilidade', (tester) async {
      await _pumpForm(tester);

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).obscureText,
        isTrue,
      );

      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).obscureText,
        isFalse,
      );
    });

    testWidgets('envia cpf e senha digitados ao entrar', (tester) async {
      final controller = TextEditingController();
      final credentials = await _pumpForm(tester, controller: controller);

      await tester.enterText(find.byType(TextFormField), 'Senha@123');
      await tester.tap(find.text('login_tablet_sign_sign'));
      await tester.pumpAndSettle();

      expect(credentials.single.username, '12345678901');
      expect(credentials.single.password, 'Senha@123');
    });

    testWidgets('não exibe mensagem de erro quando não há falha',
        (tester) async {
      await _pumpForm(tester);

      expect(find.text('Usuário ou senha inválidos'), findsNothing);
    });

    testWidgets('exibe a mensagem de erro recebida', (tester) async {
      await _pumpForm(tester, errorMessage: 'Usuário ou senha inválidos');

      expect(find.text('Usuário ou senha inválidos'), findsOneWidget);
    });
  });
}
