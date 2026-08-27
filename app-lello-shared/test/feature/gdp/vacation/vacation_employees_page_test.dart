import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/employees/vacation_employees_bloc.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/employees/vacation_employees_state.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/page/vacation_employees_page.dart';
import 'package:shared_features/shared_features.dart';

import '../../../helpers/pump_app.dart';
import 'vacation_test_helpers.dart';

void main() {
  late VacationEnv env;
  late RecordingNavigatorObserver observer;

  setUp(() {
    env = VacationEnv();
    observer = RecordingNavigatorObserver();
  });

  Future<VacationEmployeesBloc> pumpEmployees(WidgetTester tester,
      {bool settle = true}) async {
    final bloc = env.employeesBloc();
    await pumpPage(
      tester,
      VacationEmployeesPage(appContainer: env.container(employees: bloc)),
      observer: observer,
      settle: settle,
    );
    return bloc;
  }

  testWidgets('lista os funcionários e navega para as férias ao tocar',
      (tester) async {
    env.stubEmployees([
      employeeJson('E1', name: 'Ana'),
      employeeJson('E2', name: 'Bia'),
    ]);

    await pumpEmployees(tester);

    expect(find.text('gdp_vacation_title'), findsOneWidget);
    expect(find.text('gdp_vacation_choose_employee'), findsOneWidget);
    expect(find.text('gdp_vacation_employees_search_tooltip'), findsOneWidget);
    expect(find.text('Ana'), findsOneWidget);
    expect(find.text('Bia'), findsOneWidget);
    expect(find.text('Porteiro'), findsNWidgets(2));

    await tester.tap(find.text('Ana'));
    await tester.pumpAndSettle();

    expect(observer.pushedNames.last, SharedApplicationRoute.gdpVacation);
    expect(findRoute(SharedApplicationRoute.gdpVacation), findsOneWidget);
    final args = observer.pushed.last.settings.arguments as Employee;
    expect(args.id, 'E1');
    expect(args.name, 'Ana');
  });

  testWidgets('golden da lista de funcionários', (tester) async {
    env.stubEmployees([
      employeeJson('E1', name: 'Ana Souza'),
      employeeJson('E2', name: 'Bruno Lima'),
    ]);
    await pumpEmployees(tester);
    await expectLater(find.byType(VacationEmployeesPage),
        matchesGoldenFile('goldens/vacation_employees_page.png'));
  });

  testWidgets('sem funcionários mostra a mensagem de vazio', (tester) async {
    env.stubEmployees([]);
    await pumpEmployees(tester);
    expect(find.text('gdp_vacation_employees_no_panding_vacation'),
        findsOneWidget);
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('falha no carregamento sem dados mostra a mensagem de vazio',
      (tester) async {
    env.http.failAll();
    final bloc = await pumpEmployees(tester);
    expect(bloc.state, isA<VacationEmployeesLoadFailedState>());
    expect(find.text('gdp_vacation_employees_no_panding_vacation'),
        findsOneWidget);
  });

  /// Defeito: no estado de carregamento o `Center(LoadingWidget())` é criado
  /// mas não é retornado pelo builder (falta o `return`), então a tela fica
  /// vazia enquanto carrega.
  testWidgets('estado de carregamento não mostra o indicador', (tester) async {
    env.stubEmployees([employeeJson('E1', name: 'Ana')]);
    final bloc = await pumpEmployees(tester);
    expect(find.text('Ana'), findsOneWidget);

    // ignore: invalid_use_of_visible_for_testing_member
    bloc.emit(VacationEmployeesLoadingState(bloc.state.data, '', condominiumId));
    await tester.pump();
    await tester.pump();

    expect(find.byType(LoadingWidget), findsNothing);
    expect(find.byType(ListTile), findsNothing);
    expect(find.text('Ana'), findsNothing);

    // ignore: invalid_use_of_visible_for_testing_member
    bloc.emit(VacationEmployeesLoadedState(bloc.state.data, '', condominiumId, false));
    await tester.pumpAndSettle();
    expect(find.text('Ana'), findsOneWidget);
  });

  testWidgets('digitar no campo de busca filtra por nome', (tester) async {
    env.stubEmployees([
      employeeJson('E1', name: 'Ana'),
      employeeJson('E2', name: 'Bia'),
    ]);
    final bloc = await pumpEmployees(tester);
    env.http.requests.clear();
    env.stubEmployees([employeeJson('E1', name: 'Ana')]);

    await tester.enterText(find.byType(TextField), 'An');
    await tester.pumpAndSettle();

    expect(bloc.state, isA<VacationEmployeesLoadedState>());
    expect(bloc.state.query, 'An');
    expect(find.text('Ana'), findsOneWidget);
    expect(find.text('Bia'), findsNothing);
    expect(env.http.requests.single.url.queryParameters['name'], 'An');

    /// Defeito: durante a busca (`VacationEmployeesSearchingState`) o builder
    /// devolve um `Container()` vazio — a lista e o próprio campo de busca
    /// somem da tela (e o indicador de busca nunca aparece).
    // ignore: invalid_use_of_visible_for_testing_member
    bloc.emit(VacationEmployeesSearchingState(bloc.state.data, 'An', condominiumId));
    await tester.pump();
    await tester.pump();
    expect(find.byType(TextField), findsNothing);
    expect(find.byType(LoadingWidget), findsNothing);
    expect(find.text('Ana'), findsNothing);
  });

  /// Defeito: com dados já carregados, uma falha (`LoadFailedState`) faz o
  /// builder devolver `Container()` — a lista some sem nenhuma mensagem.
  testWidgets('falha com dados carregados esvazia a tela', (tester) async {
    env.stubEmployees([employeeJson('E1', name: 'Ana')]);
    final bloc = await pumpEmployees(tester);

    env.http.failAll();
    bloc.beginSearch('x');
    await tester.pumpAndSettle();

    expect(bloc.state, isA<VacationEmployeesLoadFailedState>());
    expect(bloc.state.data, isNotEmpty);
    expect(find.text('Ana'), findsNothing);
    expect(find.text('gdp_vacation_employees_no_panding_vacation'),
        findsNothing);
  });

  testWidgets('rolar até o fim carrega a próxima página', (tester) async {
    env.stubEmployees(List.generate(
        15, (i) => employeeJson('E$i', name: 'Funcionário $i')));
    final bloc = await pumpEmployees(tester);
    env.http.requests.clear();
    env.stubEmployees([employeeJson('E99', name: 'Último')]);

    await tester.drag(find.byType(ListView), const Offset(0, -3000));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(env.http.requests, isNotEmpty);
    expect(env.http.requests.first.url.queryParameters['last_employee_id'],
        'E14');
    expect((bloc.state as VacationEmployeesLoadedState).data, hasLength(16));

    await tester.drag(find.byType(ListView), const Offset(0, -3000));
    await tester.pumpAndSettle();
    expect(find.text('Último'), findsOneWidget);
  });

  testWidgets('puxar para atualizar recarrega a lista', (tester) async {
    env.stubEmployees([employeeJson('E1', name: 'Ana')]);
    final bloc = await pumpEmployees(tester);
    env.http.requests.clear();
    env.stubEmployees([
      employeeJson('E1', name: 'Ana'),
      employeeJson('E2', name: 'Bia'),
    ]);

    final indicator =
        tester.state<RefreshIndicatorState>(find.byType(RefreshIndicator));
    unawaited(indicator.show());
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(env.http.requests, hasLength(1));
    expect(bloc.state, isA<VacationEmployeesLoadedState>());
    expect(find.text('Bia'), findsOneWidget);
  });
}
