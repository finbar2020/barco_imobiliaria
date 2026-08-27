import 'dart:async';

import 'package:essentials/essentials.dart' hide isNull, isNotNull, Address;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/employee/presentation/bloc/list/employee_list_bloc.dart';
import 'package:shared_features/feature/gdp/employee/presentation/bloc/list/employee_list_state.dart';
import 'package:shared_features/feature/gdp/employee/presentation/page/employee_list_page.dart';
import 'package:shared_features/feature/gdp/employee/presentation/widget/employee_filter_widget.dart';
import 'package:shared_features/feature/gdp/employee/presentation/widget/employee_list_item.dart';
import 'package:shared_features/shared_features.dart';

import '../../../helpers/firebase_mocks.dart';
import '../../../helpers/pump_app.dart';
import 'gdp_rest_test_helpers.dart';

void main() {
  late GdpEnv env;
  late RecordingNavigatorObserver observer;

  setUpAll(() async {
    await setUpFakeFirebase();
  });

  setUp(() {
    env = GdpEnv();
    observer = RecordingNavigatorObserver();
  });

  /// O bloc é registrado como factory: nasce no `initState` da página, como
  /// no app, e a página acompanha o carregamento desde o início.
  Future<EmployeeListBloc Function()> pumpList(WidgetTester tester,
      {bool settle = true, bool pushed = false, bool withSession = true}) async {
    EmployeeListBloc? bloc;
    final container = env.container()
      ..registerFactory<EmployeeListBloc>(() => bloc = EmployeeListBloc(
          sessionBloc: withSession ? env.session : null,
          listEmployee: env.listEmployee,
          appOriginEnum: AppOriginEnum.manager));
    final page = EmployeeListPage(appContainer: container);
    if (pushed) {
      await pumpPushed(tester, page, observer: observer, settle: settle);
    } else {
      await pumpPage(tester, page, observer: observer, settle: settle);
    }
    return () => bloc!;
  }

  testWidgets('lista os funcionários e navega para o detalhe ao tocar',
      (tester) async {
    env.stubEmployees([
      employeeJson('E1', name: 'Ana'),
      employeeJson('E2', name: 'Bia'),
    ]);
    final bloc = await pumpList(tester);

    expect(bloc().state, isA<EmployeeListLoadedState>());
    expect(find.text('gdp_team'), findsOneWidget);
    expect(find.byType(EmployeeListItem), findsNWidgets(2));
    expect(find.text('Ana'), findsOneWidget);
    expect(find.text('Bia'), findsOneWidget);

    await tester.tap(find.text('Ana'));
    await tester.pumpAndSettle();

    expect(observer.pushedNames.last, SharedApplicationRoute.gdpEmployee);
    expect(findRoute(SharedApplicationRoute.gdpEmployee), findsOneWidget);
    expect((observer.pushed.last.settings.arguments as Employee).id, 'E1');
  });

  testWidgets('golden da lista', (tester) async {
    env.stubEmployees([employeeJson('E1', name: 'Ana Souza')]);
    await pumpList(tester);
    await expectLater(find.byType(EmployeeListPage),
        matchesGoldenFile('goldens/employee_list_page.png'));
  });

  testWidgets('sem funcionários mostra "Nenhum registro encontrado"',
      (tester) async {
    env.stubEmployees([]);
    await pumpList(tester);
    expect(find.text('Nenhum registro encontrado'), findsOneWidget);
    expect(find.byType(EmployeeListItem), findsNothing);
  });

  testWidgets('enquanto carrega mostra a lista vazia com o indicador de refresh',
      (tester) async {
    final bloc = await pumpList(tester, withSession: false);
    expect(bloc().state, isA<EmployeeListLoadingState>());
    expect(find.byType(RefreshIndicator), findsOneWidget);
    expect(find.byType(EmployeeListItem), findsNothing);
    expect(find.text('Nenhum registro encontrado'), findsNothing);
    expect(env.http.requests, isEmpty);
  });

  /// Defeito: todo estado de carregamento chama `_indicatorKey.currentState.show()`;
  /// quando a animação do RefreshIndicator termina, o `onRefresh` chama
  /// `bloc.beginRefresh()` com a lista já carregada e a tela busca a lista
  /// remota uma segunda vez (cache + remoto + remoto de novo).
  testWidgets('abrir a tela dispara o carregamento remoto duas vezes',
      (tester) async {
    env.stubEmployees([employeeJson('E1', name: 'Ana')]);
    await pumpList(tester);
    expect(env.paths, [employeesPath, employeesPath, employeesPath]);
  });

  /// Defeito: o corpo de erro usa `Center(child: Expanded(...))` — `Expanded`
  /// só pode ficar dentro de `Flex`, e o Flutter lança "Incorrect use of
  /// ParentDataWidget" ao montar a mensagem de erro.
  testWidgets('falha no carregamento mostra a mensagem mas lança erro de layout',
      (tester) async {
    env.http.failAll();
    final bloc = await pumpList(tester);
    expect(bloc().state, isA<EmployeeListLoadFailedState>());
    final exception = tester.takeException();
    expect(exception, isNotNull);
    expect('$exception', contains('ParentDataWidget'));
    expect(find.text('Ocorreu um erro, tente novamente mais tarde'),
        findsOneWidget);
    expect(find.byType(RefreshIndicator), findsNothing);
  });

  testWidgets('o botão de voltar fecha a página', (tester) async {
    env.stubEmployees([employeeJson('E1', name: 'Ana')]);
    await pumpList(tester, pushed: true);
    expect(find.byType(EmployeeListPage), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();

    expect(find.byType(EmployeeListPage), findsNothing);
    expect(find.byKey(const Key('host')), findsOneWidget);
  });

  testWidgets('a lupa abre o filtro; o ícone do título fecha', (tester) async {
    env.stubEmployees([employeeJson('E1', name: 'Ana')]);
    await pumpList(tester);

    await tester.tap(find.byIcon(Icons.search).first);
    await tester.pumpAndSettle();
    expect(find.byType(EmployeeFilterWidget), findsOneWidget);
    expect(find.text('payment_filter_title'), findsOneWidget);

    // o ícone dentro do título do drawer fecha o drawer
    await tester.tap(find.descendant(
        of: find.byType(Drawer), matching: find.byIcon(Icons.search)));
    await tester.pumpAndSettle();
    expect(find.byType(EmployeeFilterWidget), findsNothing);
  });

  testWidgets('aplicar o filtro recarrega a lista com os parâmetros',
      (tester) async {
    env.stubEmployees([employeeJson('E1', name: 'Ana')]);
    final bloc = await pumpList(tester);
    env.http.requests.clear();
    env.stubEmployees([employeeJson('E3', name: 'Carla')]);

    await tester.tap(find.byIcon(Icons.search).first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Car');
    await tester.enterText(find.byType(TextFormField).at(1), 'Zelador');
    await tester.ensureVisible(find.text('search'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('search'));
    await tester.pumpAndSettle();

    expect(find.byType(EmployeeFilterWidget), findsNothing);
    // mesmo defeito do refresh: o filtro também é buscado duas vezes
    expect(env.paths, [employeesPath, employeesPath]);
    final query = env.http.requests.first.url.queryParameters;
    expect(query['name'], 'Car');
    expect(query['role'], 'Zelador');
    expect(bloc().state.filter.name, 'Car');
    expect(find.text('Carla'), findsOneWidget);
  });

  testWidgets('rolar até o fim carrega a próxima página', (tester) async {
    env.stubEmployees(
        List.generate(6, (i) => employeeJson('E$i', name: 'Funcionário $i')));
    final bloc = await pumpList(tester);
    env.http.requests.clear();
    env.stubEmployees([employeeJson('E99', name: 'Último')]);

    await tester.drag(find.byType(ListView), const Offset(0, -5000));
    await tester.pump();
    await tester.pumpAndSettle();

    // cada rolagem até o fim pede a página seguinte a partir do último id
    expect(env.http.requests, isNotEmpty);
    expect(env.http.requests.first.url.queryParameters['last_employee_id'],
        'E5');
    expect((bloc().state as EmployeeListLoadedState).data.length,
        6 + env.http.requests.length);
    expect(find.text('Último'), findsWidgets);
  });

  testWidgets('puxar para atualizar recarrega a lista', (tester) async {
    env.stubEmployees([employeeJson('E1', name: 'Ana')]);
    final bloc = await pumpList(tester);
    env.http.requests.clear();
    env.stubEmployees([employeeJson('E1', name: 'Ana'), employeeJson('E2', name: 'Bia')]);

    final indicator =
        tester.state<RefreshIndicatorState>(find.byType(RefreshIndicator));
    unawaited(indicator.show());
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(env.http.requests, hasLength(1));
    expect(bloc().state, isA<EmployeeListLoadedState>());
    expect(find.text('Bia'), findsOneWidget);
  });
}
