import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull, Address;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee_list_filter.dart';
import 'package:shared_features/feature/gdp/employee/presentation/bloc/employee/employee_bloc.dart';
import 'package:shared_features/feature/gdp/employee/presentation/bloc/employee/employee_event.dart';
import 'package:shared_features/feature/gdp/employee/presentation/bloc/employee/employee_state.dart';
import 'package:shared_features/feature/gdp/employee/presentation/bloc/list/employee_list_bloc.dart';
import 'package:shared_features/feature/gdp/employee/presentation/bloc/list/employee_list_event.dart';
import 'package:shared_features/feature/gdp/employee/presentation/bloc/list/employee_list_state.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../../helpers/firebase_mocks.dart';
import 'gdp_rest_test_helpers.dart';

void main() {
  late GdpEnv env;

  setUpAll(() async {
    await setUpFakeFirebase();
  });

  setUp(() {
    env = GdpEnv();
    fakeAnalytics.reset();
  });

  group('EmployeeBloc', () {
    test('estado inicial é carregando sem dados', () {
      final bloc = EmployeeBloc(sessionBloc: env.session, getEmployee: env.getEmployee);
      expect(bloc.state, isA<EmployeeLoadingState>());
      expect(bloc.state.data, isNull);
      expect(bloc.state.condominiumId, isNull);
      expect(bloc.state.props, [null, null]);
      bloc.close();
    });

    test('beginLoad sem sessão não dispara evento', () async {
      final bloc = EmployeeBloc(sessionBloc: null, getEmployee: env.getEmployee);
      bloc.beginLoad('E1');
      await drain();
      expect(env.http.requests, isEmpty);
      expect(bloc.state, isA<EmployeeLoadingState>());
      await bloc.close();
    });

    test('beginLoad busca o funcionário e emite carregando -> carregado', () async {
      env.stubEmployee(employeeJson('E1', name: 'Ana'));
      final bloc = EmployeeBloc(sessionBloc: env.session, getEmployee: env.getEmployee);
      final states = <EmployeeState>[];
      bloc.stream.listen(states.add);

      bloc.beginLoad('E1');
      await drain();

      expect(env.paths, ['/condominiums/C1/employees/E1']);
      expect(states, hasLength(2));
      expect(states[0], isA<EmployeeLoadingState>());
      expect(states[0].condominiumId, 'C1');
      expect(states[1], isA<EmployeeLoadedState>());
      expect(states[1].data?.name, 'Ana');
      expect(states[1].data?.address?.number, '10');
      await bloc.close();
    });

    test('falha com dados já carregados mantém os dados no estado de erro', () async {
      env.stubEmployee(employeeJson('E1', name: 'Ana'));
      final bloc = EmployeeBloc(sessionBloc: env.session, getEmployee: env.getEmployee);
      bloc.beginLoad('E1');
      await drain();
      expect(bloc.state, isA<EmployeeLoadedState>());

      env.http.failAll();
      bloc.beginLoad('E1');
      await drain();

      final failed = bloc.state as EmployeeLoadFailedState;
      expect(failed.data?.name, 'Ana');
      expect(failed.error, isA<UnknownFailure>());
      expect(failed.props, hasLength(3));
      await bloc.close();
    });

    /// Defeito: `EmployeeLoadFailedState(data!, ...)` usa `!` no dado
    /// anterior; quando a primeira busca falha ainda não há dado e o handler
    /// estoura com "Null check operator used on a null value" em vez de
    /// emitir o estado de erro.
    test('falha na primeira busca estoura em vez de emitir erro', () async {
      env.http.failAll();
      late EmployeeBloc bloc;
      final errors = await collectUncaught(() async {
        bloc = EmployeeBloc(sessionBloc: env.session, getEmployee: env.getEmployee);
        bloc.beginLoad('E1');
        await drain();
      });
      expect(errors, isNotEmpty);
      expect(errors.first, isA<TypeError>());
      expect(bloc.state, isA<EmployeeLoadingState>());
      await bloc.close();
    });

    test('eventos são comparáveis por valor', () {
      expect(const EmployeeLoadEvent(condominiumId: 'C1', employeeId: 'E1'),
          const EmployeeLoadEvent(condominiumId: 'C1', employeeId: 'E1'));
      expect(const EmployeeLoadEvent(condominiumId: 'C1', employeeId: 'E1').props,
          ['C1', 'E1']);
    });
  });

  group('EmployeeListBloc', () {
    EmployeeListBloc build({SharedSession? session, AppOriginEnum origin = AppOriginEnum.manager}) =>
        EmployeeListBloc(
            sessionBloc: session, listEmployee: env.listEmployee, appOriginEnum: origin);

    test('sem sessão fica no estado inicial com filtro "ativo"', () async {
      final bloc = build();
      await drain();
      expect(bloc.state, isA<EmployeeListLoadingState>());
      expect(bloc.state.data, isEmpty);
      expect(bloc.state.filter.conditionName, 'ativo');
      expect(env.http.requests, isEmpty);
      await bloc.close();
    });

    test('com sessão carrega o cache local e depois o remoto', () async {
      env.stubEmployees([employeeJson('E1', name: 'Ana'), employeeJson('E2', name: 'Bia')]);
      final states = <EmployeeListState>[];
      final bloc = build(session: env.session);
      bloc.stream.listen(states.add);
      await drain();

      // origem local + remota passam pelo mesmo data source remoto
      expect(env.paths, [employeesPath, employeesPath]);
      expect(env.http.requests.first.url.queryParameters['condition_name'], 'ativo');
      expect(states, hasLength(2));
      expect(states[0], isA<EmployeeListLoadingState>());
      expect(states[0].data, hasLength(2)); // dados do cache
      final loaded = states[1] as EmployeeListLoadedState;
      expect(loaded.data.map((e) => e.name), ['Ana', 'Bia']);
      expect(loaded.condominiumId, 'C1');
      expect(loaded.donePaging, isFalse);
      expect(bloc.loadedCache, isTrue);
      // com filtro "ativo" não há evento de analytics
      expect(fakeAnalytics.eventNames, isEmpty);
      await bloc.close();
    });

    test('lista vazia marca donePaging', () async {
      env.stubEmployees([]);
      final bloc = build(session: env.session);
      await drain();
      expect((bloc.state as EmployeeListLoadedState).donePaging, isTrue);
      await bloc.close();
    });

    test('falha no remoto emite LoadFailed mantendo o cache', () async {
      env.http.failAll();
      final bloc = build(session: env.session);
      await drain();
      final failed = bloc.state as EmployeeListLoadFailedState;
      expect(failed.data, isEmpty);
      expect(failed.error, isA<UnknownFailure>());
      expect(failed.props.last, failed.error);
      await bloc.close();
    });

    test('beginFilter sem conditionName remove demitidos e loga analytics (síndico)', () async {
      env.stubEmployees([employeeJson('E1', name: 'Ana')]);
      final bloc = build(session: env.session);
      await drain();
      env.http.requests.clear();
      env.stubEmployees([
        employeeJson('E1', name: 'Ana'),
        employeeJson('E2', name: 'Bia', status: 'demitido'),
      ]);

      bloc.beginFilter(EmployeeListFilter(name: 'a'));
      await drain();

      // cache já carregado: só uma chamada
      expect(env.paths, [employeesPath]);
      final query = env.http.requests.single.url.queryParameters;
      expect(query['name'], 'a');
      expect(query.containsKey('condition_name'), isFalse);
      final loaded = bloc.state as EmployeeListLoadedState;
      expect(loaded.data.map((e) => e.name), ['Ana']);
      expect(loaded.filter.name, 'a');
      expect(fakeAnalytics.eventNames, ['dados_equipe_acessar']);
      expect(fakeAnalytics.events['dados_equipe_acessar']?['referencia'], 'R1');
      expect(fakeAnalytics.events['dados_equipe_acessar']?['unidade'], '101');
      await bloc.close();
    });

    test('analytics com origem funcionário e sem sessão', () async {
      env.stubEmployees([employeeJson('E1')]);
      final bloc = build(session: env.session, origin: AppOriginEnum.employee);
      await drain();
      bloc.beginFilter(EmployeeListFilter());
      await drain();
      expect(fakeAnalytics.eventNames, ['dados_equipe_acessar']);
      await bloc.close();
    });

    test('beginLoadNextPage pagina a partir do último id e concatena', () async {
      env.stubEmployees([employeeJson('E1', name: 'Ana')]);
      final bloc = build(session: env.session);
      await drain();
      env.http.requests.clear();
      env.stubEmployees([employeeJson('E2', name: 'Bia')]);
      final states = <EmployeeListState>[];
      bloc.stream.listen(states.add);

      bloc.beginLoadNextPage();
      await drain();

      expect(env.http.requests.single.url.queryParameters['last_employee_id'], 'E1');
      expect(states[0], isA<EmployeeListPagingState>());
      final loaded = states[1] as EmployeeListLoadedState;
      expect(loaded.data.map((e) => e.name), ['Ana', 'Bia']);
      expect(loaded.donePaging, isFalse);

      // página vazia encerra a paginação e bloqueia novas páginas
      env.http.requests.clear();
      env.stubEmployees([]);
      bloc.beginLoadNextPage();
      await drain();
      expect((bloc.state as EmployeeListLoadedState).donePaging, isTrue);
      bloc.beginLoadNextPage();
      await drain();
      expect(env.http.requests, hasLength(1));
      await bloc.close();
    });

    test('falha ao paginar emite PageFailed com os dados atuais', () async {
      env.stubEmployees([employeeJson('E1', name: 'Ana')]);
      final bloc = build(session: env.session);
      await drain();
      env.http.failAll();

      bloc.beginLoadNextPage();
      await drain();

      final failed = bloc.state as EmployeeListPageFailedState;
      expect(failed.data.single.name, 'Ana');
      expect(failed.error, isA<UnknownFailure>());
      expect(failed.props, hasLength(4));
      await bloc.close();
    });

    test('beginRefresh recarrega só quando não está carregando/paginando', () async {
      env.stubEmployees([employeeJson('E1', name: 'Ana')]);
      final bloc = build(session: env.session);
      // ainda carregando: ignorado
      bloc.beginRefresh();
      await drain();
      expect(env.paths, [employeesPath, employeesPath]);

      env.http.requests.clear();
      bloc.beginRefresh();
      await drain();
      expect(env.paths, [employeesPath]);
      expect(bloc.state, isA<EmployeeListLoadedState>());

      // paginando: ignorado
      // ignore: invalid_use_of_visible_for_testing_member
      bloc.emit(EmployeeListPagingState(bloc.state.data, 'C1', bloc.state.filter));
      env.http.requests.clear();
      bloc.beginRefresh();
      bloc.beginLoadNextPage();
      await drain();
      expect(env.http.requests, isEmpty);
      await bloc.close();
    });

    test('eventos e estados comparáveis por valor', () {
      final filter = EmployeeListFilter();
      expect(EmployeeListLoadEvent(condominiumId: 'C1', filter: filter),
          EmployeeListLoadEvent(condominiumId: 'C1', filter: filter));
      expect(const EmployeeListNextPageEvent().props, isEmpty);
      final e = <Employee>[];
      expect(EmployeeListLoadedState(e, 'C1', filter, true),
          EmployeeListLoadedState(e, 'C1', filter, true));
      expect(EmployeeListLoadedState(e, 'C1', filter, true).props.last, isTrue);
    });
  });
}
