import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/employee_info.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_employees_step_widget.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_loaded_widget.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

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

EmployeeInfo _employee({
  required String name,
  String cpf = '12345678901',
  String pictureHash = '',
}) =>
    EmployeeInfo(
      numCra: '1',
      numCad: '2',
      cpf: cpf,
      name: name,
      jobPosition: 'PORTEIRO',
      idLogin: 'l1',
      pictureHash: pictureHash,
      registered: true,
      statusEnum: DigitalTimesheetStatusEnum.approved,
    );

void main() {
  setUp(_installContainer);
  tearDown(resetTestApplicationContainer);

  final employees = [
    _employee(name: 'ANA SILVA'),
    _employee(name: 'BRUNO SOUZA', cpf: '98765432100'),
    _employee(name: 'CARLOS ANDRADE', cpf: '11122233344'),
  ];

  Future<
      ({
        List<LoginTabletSteps> steps,
        List<EmployeeInfo> selected,
      })> pumpStep(WidgetTester tester) async {
    final steps = <LoginTabletSteps>[];
    final selected = <EmployeeInfo>[];

    await pumpApp(
      tester,
      LoginTabletEmployeesStepWidget(
        employees: employees,
        changeStep: steps.add,
        onEmployeeSelected: selected.add,
      ),
      localized: true,
      shrinkWrap: false,
      surface: const Size(800, 900),
    );

    return (steps: steps, selected: selected);
  }

  group('LoginTabletEmployeesStepWidget', () {
    testWidgets('lista todos os colaboradores do condomínio', (tester) async {
      await pumpStep(tester);

      expect(find.text('login_tablet_select_profile'), findsOneWidget);
      expect(find.text('Ana Silva'), findsOneWidget);
      expect(find.text('Bruno Souza'), findsOneWidget);
      expect(find.text('Carlos Andrade'), findsOneWidget);
    });

    testWidgets('filtra colaboradores pelo nome digitado', (tester) async {
      await pumpStep(tester);

      await tester.enterText(find.byType(TextFormField), 'bru');
      await tester.pumpAndSettle();

      expect(find.text('Bruno Souza'), findsOneWidget);
      expect(find.text('Ana Silva'), findsNothing);
      expect(find.text('Carlos Andrade'), findsNothing);
    });

    testWidgets('busca ignora maiúsculas e minúsculas', (tester) async {
      await pumpStep(tester);

      await tester.enterText(find.byType(TextFormField), 'ANA');
      await tester.pumpAndSettle();

      expect(find.text('Ana Silva'), findsOneWidget);
      expect(find.text('Bruno Souza'), findsNothing);
    });

    testWidgets('lista fica vazia quando nada corresponde à busca',
        (tester) async {
      await pumpStep(tester);

      await tester.enterText(find.byType(TextFormField), 'zzz');
      await tester.pumpAndSettle();

      expect(find.text('Ana Silva'), findsNothing);
      expect(find.text('Bruno Souza'), findsNothing);
      expect(find.text('Carlos Andrade'), findsNothing);
    });

    testWidgets('botão limpar restaura a lista completa', (tester) async {
      await pumpStep(tester);

      await tester.enterText(find.byType(TextFormField), 'ana');
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.clear), findsOneWidget);

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      expect(find.text('Ana Silva'), findsOneWidget);
      expect(find.text('Bruno Souza'), findsOneWidget);
      expect(find.text('Carlos Andrade'), findsOneWidget);
    });

    testWidgets('seleciona o colaborador tocado na lista', (tester) async {
      final result = await pumpStep(tester);

      await tester.tap(find.text('Bruno Souza'));
      await tester.pumpAndSettle();

      expect(result.selected.single.name, 'BRUNO SOUZA');
    });

    testWidgets('voltar retorna para o passo do código do condomínio',
        (tester) async {
      final result = await pumpStep(tester);

      await tester.tap(find.byIcon(Icons.arrow_back_ios_rounded));
      await tester.pumpAndSettle();

      expect(result.steps, [LoginTabletSteps.condominiumName]);
    });

    testWidgets('exibe cpf mascarado de cada colaborador', (tester) async {
      await pumpStep(tester);

      expect(find.text('login_tablet_sign_cpf'), findsNWidgets(3));
      expect(
        find.text(LgpdFormatter.formatCpf('12345678901')),
        findsOneWidget,
      );
    });
  });
}
