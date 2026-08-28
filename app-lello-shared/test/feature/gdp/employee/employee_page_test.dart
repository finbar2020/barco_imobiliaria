import 'package:essentials/essentials.dart' hide isNull, isNotNull, Address;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:shared_features/feature/gdp/employee/presentation/bloc/employee/employee_bloc.dart';
import 'package:shared_features/feature/gdp/employee/presentation/bloc/employee/employee_state.dart';
import 'package:shared_features/feature/gdp/employee/presentation/page/employee_page.dart';

import '../../../helpers/fake_url_launcher.dart';
import '../../../helpers/pump_app.dart';
import 'gdp_rest_test_helpers.dart';

void main() {
  late GdpEnv env;

  setUp(() => env = GdpEnv());

  Future<EmployeeBloc> pumpEmployee(WidgetTester tester,
      {bool settle = true, bool withSession = true}) async {
    final bloc = EmployeeBloc(
        sessionBloc: withSession ? env.session : null,
        getEmployee: env.getEmployee);
    final container = env.container()..register<EmployeeBloc>(bloc);
    await pumpPage(
      tester,
      EmployeePage(appContainer: container),
      arguments: employee(),
      settle: settle,
      surface: const Size(400, 900),
    );
    return bloc;
  }

  testWidgets('mostra todos os dados do funcionário', (tester) async {
    await mockNetworkImagesFor(() async {
      env.stubEmployee(employeeJson('E1', name: 'Ana'));
      final bloc = await pumpEmployee(tester);

      expect(bloc.state, isA<EmployeeLoadedState>());
      expect(env.paths, ['/condominiums/C1/employees/E1']);
      expect(find.text('gdp_employee_detail'), findsOneWidget);
      expect(find.text('gdp_employee_data'), findsOneWidget);
      expect(find.text('Ana'), findsOneWidget);
      expect(find.text('Rua A'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
      expect(find.text('ap 1'), findsOneWidget);
      expect(find.text('11999999999'), findsOneWidget);
      expect(find.text('1133333333'), findsOneWidget);
      expect(find.text('Porteiro'), findsOneWidget);
      expect(find.text('ATIVO'), findsOneWidget);
      expect(find.text('Médio'), findsOneWidget);
      expect(find.text(NumberFormat.currency(symbol: 'R\$').format(2500.5)),
          findsOneWidget);

      /// Corrigido: o campo "gdp_hiring_date" mostra a data de admissão
      /// (`hiringDate`) e não mais a data de nascimento (`dob`).
      final dob = DateFormat.yMd().format(DateTime(1990, 1, 2));
      final hiring = DateFormat.yMd().format(DateTime(2020, 3, 4));
      expect(find.text(dob), findsOneWidget);
      expect(find.text(hiring), findsOneWidget);

      await expectLater(find.byType(EmployeePage),
          matchesGoldenFile('goldens/employee_page.png'));
    });
  });

  testWidgets('botões de telefone e sms abrem o discador', (tester) async {
    await mockNetworkImagesFor(() async {
      final launcher = installFakeUrlLauncher();
      env.stubEmployee(employeeJson('E1', name: 'Ana'));
      await pumpEmployee(tester);

      await tester.tap(find.byIcon(Icons.phone));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.sms_rounded));
      await tester.pumpAndSettle();

      expect(launcher.launched, ['tel://11999999999', 'sms://11999999999']);
    });
  });

  testWidgets('sem telefone os botões não fazem nada e campos vazios viram "-"',
      (tester) async {
    await mockNetworkImagesFor(() async {
      final launcher = installFakeUrlLauncher();
      env.stubEmployee(employeeJson('E1', name: 'Ana', role: null, full: false));
      await pumpEmployee(tester);

      expect(find.text('-'), findsNWidgets(9));
      expect(find.text(NumberFormat.currency(symbol: 'R\$').format(2500.5)),
          findsOneWidget);
      await tester.tap(find.byIcon(Icons.phone));
      await tester.tap(find.byIcon(Icons.sms_rounded));
      await tester.pumpAndSettle();
      expect(launcher.launched, isEmpty);
    });
  });

  testWidgets('enquanto carrega mostra o indicador', (tester) async {
    await mockNetworkImagesFor(() async {
      env.stubEmployee(employeeJson('E1'));
      final bloc = await pumpEmployee(tester, settle: false, withSession: false);
      expect(bloc.state, isA<EmployeeLoadingState>());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(env.http.requests, isEmpty);
    });
  });

  testWidgets('falha após carregar mantém os dados na tela sem mensagem',
      (tester) async {
    await mockNetworkImagesFor(() async {
      env.stubEmployee(employeeJson('E1', name: 'Ana'));
      final bloc = await pumpEmployee(tester);
      env.http.failAll();

      bloc.beginLoad('E1');
      await tester.pumpAndSettle();

      expect(bloc.state, isA<EmployeeLoadFailedState>());
      expect(find.text('Ana'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
