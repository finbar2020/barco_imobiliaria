import 'package:essentials/essentials.dart' hide isNull, isNotNull, Address;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/payslip/domain/entity/payslipFile.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/bloc/employees/payslip_employees_bloc.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/bloc/employees/payslip_employees_event.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/bloc/employees/payslip_employees_state.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/bloc/selection/payslip_selection_bloc.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/bloc/selection/payslip_selection_event.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/bloc/selection/payslip_selection_state.dart';

import 'payslip_test_helpers.dart';

void main() {
  late PayslipEnv env;
  final mes = DateTime(2026, 8);

  setUp(() => env = PayslipEnv());

  group('PayslipEmployeesBloc', () {
    test('sem sessão fica no estado inicial', () async {
      final bloc = env.employeesBloc(withSession: false);
      await drain();
      expect(bloc.state, isA<PayslipEmployeesLoadingState>());
      expect(bloc.state.data, isEmpty);
      expect(bloc.state.props, [<Object>[], null, null, null]);
      expect(env.http.requests, isEmpty);
      await bloc.close();
    });

    test('com sessão carrega cache + remoto com filtro "ativo"', () async {
      env.stubEmployees([employeeJson('E1', name: 'Ana'), employeeJson('E2', name: 'Bia')]);
      final states = <PayslipEmployeesState>[];
      final bloc = env.employeesBloc();
      bloc.state.selectedMonth = mes;
      bloc.stream.listen(states.add);
      await drain();

      expect(env.paths, [employeesPath, employeesPath]);
      expect(env.http.requests.first.url.queryParameters['condition_name'], 'ativo');
      expect(states, hasLength(2));
      expect(states[0], isA<PayslipEmployeesLoadingState>());
      expect(states[0].data, hasLength(2));
      final loaded = states[1] as PayslipEmployeesLoadedState;
      expect(loaded.data.map((e) => e.name), ['Ana', 'Bia']);
      expect(loaded.condominiumId, 'C1');
      expect(loaded.selectedMonth, mes); // capturado no início do handler
      expect(loaded.donePaging, isFalse);
      expect(bloc.loadedCache, isTrue);
      await bloc.close();
    });

    test('lista vazia marca donePaging e bloqueia paginação', () async {
      env.stubEmployees([]);
      final bloc = env.employeesBloc();
      await drain();
      expect((bloc.state as PayslipEmployeesLoadedState).donePaging, isTrue);
      env.http.requests.clear();
      bloc.beginLoadNextPage();
      await drain();
      expect(env.http.requests, isEmpty);
      await bloc.close();
    });

    test('falha no carregamento com mês selecionado emite LoadFailed', () async {
      env.http.failAll();
      final bloc = env.employeesBloc();
      bloc.state.selectedMonth = mes;
      await drain();
      final failed = bloc.state as PayslipEmployeesLoadFailedState;
      expect(failed.error, isA<UnknownFailure>());
      expect(failed.selectedMonth, mes);
      expect(failed.props.last, failed.error);
      await bloc.close();
    });

    /// Defeito: `PayslipEmployeesLoadFailedState(..., selectedMonth!, err)`
    /// usa `!` no mês selecionado, que ainda é nulo no carregamento inicial
    /// (a página só o define no `build`). Uma falha nesse momento estoura o
    /// handler em vez de emitir o estado de erro.
    test('falha no carregamento inicial sem mês estoura', () async {
      env.http.failAll();
      late PayslipEmployeesBloc bloc;
      final errors = await collectUncaught(() async {
        bloc = env.employeesBloc();
        await drain();
      });
      expect(errors, isNotEmpty);
      expect(errors.first, isA<TypeError>());
      expect(bloc.state, isA<PayslipEmployeesLoadingState>());
      await bloc.close();
    });

    test('beginSearch busca por nome (sem o filtro "ativo") e emite Searching -> Loaded',
        () async {
      env.stubEmployees([employeeJson('E1', name: 'Ana'), employeeJson('E2', name: 'Bia')]);
      final bloc = env.employeesBloc();
      bloc.state.selectedMonth = mes;
      await drain();
      bloc.state.selectedMonth = mes;
      env.http.requests.clear();
      env.stubEmployees([employeeJson('E1', name: 'Ana')]);
      final states = <PayslipEmployeesState>[];
      bloc.stream.listen(states.add);

      bloc.beginSearch('An');
      await drain();

      final query = env.http.requests.single.url.queryParameters;
      expect(query['name'], 'An');
      // Defeito: a busca não repete o filtro `condition_name=ativo` do load
      expect(query.containsKey('condition_name'), isFalse);
      expect(states[0], isA<PayslipEmployeesSearchingState>());
      expect(states[0].query, 'An');
      final loaded = states[1] as PayslipEmployeesLoadedState;
      expect(loaded.data.map((e) => e.name), ['Ana']);
      expect(loaded.query, 'An');
      expect(loaded.selectedMonth, mes);
      expect(bloc.pendingSearch, isNull);
      await bloc.close();
    });

    test('busca durante carregamento fica pendente e é reexecutada após a próxima busca',
        () async {
      env.stubEmployees([employeeJson('E1', name: 'Ana')]);
      final bloc = env.employeesBloc();
      bloc.state.selectedMonth = mes;
      bloc.beginSearch('a'); // ainda carregando
      expect(bloc.pendingSearch, 'a');
      await drain();
      expect(bloc.state, isA<PayslipEmployeesLoadedState>());
      expect(bloc.state.query, isNull);
      expect(env.http.requests, hasLength(2)); // pendente não foi executada
      bloc.state.selectedMonth = mes;

      env.http.requests.clear();
      bloc.beginSearch('b');
      await drain();

      final queries = env.http.requests.map((r) => r.url.queryParameters['name']).toList();
      expect(queries, ['b', 'a', 'a']);
      expect(bloc.state.query, 'a');
      expect(bloc.pendingSearch, isNull);
      await bloc.close();
    });

    test('falha na busca emite LoadFailed mantendo os dados', () async {
      env.stubEmployees([employeeJson('E1', name: 'Ana')]);
      final bloc = env.employeesBloc();
      bloc.state.selectedMonth = mes;
      await drain();
      bloc.state.selectedMonth = mes;
      env.http.failAll();

      bloc.beginSearch('x');
      await drain();

      final failed = bloc.state as PayslipEmployeesLoadFailedState;
      expect(failed.data.single.name, 'Ana');
      expect(failed.query, 'x');
      await bloc.close();
    });

    test('beginLoadNextPage pagina e concatena; falha emite PageFailed', () async {
      env.stubEmployees([employeeJson('E1', name: 'Ana')]);
      final bloc = env.employeesBloc();
      await drain();
      bloc.state.selectedMonth = mes;
      env.http.requests.clear();
      env.stubEmployees([employeeJson('E2', name: 'Bia')]);
      final states = <PayslipEmployeesState>[];
      bloc.stream.listen(states.add);

      bloc.beginLoadNextPage();
      await drain();

      final query = env.http.requests.single.url.queryParameters;
      expect(query['last_employee_id'], 'E1');
      expect(query['condition_name'], 'ativo');
      expect(states[0], isA<PayslipEmployeesPagingState>());
      final loaded = states[1] as PayslipEmployeesLoadedState;
      expect(loaded.data.map((e) => e.name), ['Ana', 'Bia']);
      expect(loaded.selectedMonth, mes);

      env.http.failAll();
      bloc.beginLoadNextPage();
      await drain();
      final failed = bloc.state as PayslipEmployeesPageFailedState;
      expect(failed.data, hasLength(2));
      expect(failed.props, hasLength(5));

      // paginando: refresh e nova página são ignorados
      // ignore: invalid_use_of_visible_for_testing_member
      bloc.emit(PayslipEmployeesPagingState(failed.data, null, 'C1', mes));
      env.http.requests.clear();
      bloc.beginLoadNextPage();
      bloc.beginRefresh();
      await drain();
      expect(env.http.requests, isEmpty);
      await bloc.close();
    });

    test('beginRefresh recarrega quando não está carregando', () async {
      env.stubEmployees([employeeJson('E1', name: 'Ana')]);
      final bloc = env.employeesBloc();
      bloc.beginRefresh(); // carregando: ignorado
      await drain();
      expect(env.http.requests, hasLength(2));
      bloc.state.selectedMonth = mes;

      env.http.requests.clear();
      bloc.beginRefresh();
      await drain();
      expect(env.http.requests, hasLength(1));
      expect(bloc.state, isA<PayslipEmployeesLoadedState>());
      expect(bloc.state.selectedMonth, mes);
      await bloc.close();
    });

    test('eventos comparáveis por valor', () {
      expect(const PayslipEmployeesLoadEvent(condominiumId: 'C1'),
          const PayslipEmployeesLoadEvent(condominiumId: 'C1'));
      expect(const PayslipEmployeesSearchEvent(query: 'a').props, ['a']);
      expect(const PayslipEmployeesNextPageEvent().props, isEmpty);
    });
  });

  group('PayslipSelectionBloc', () {
    test('estado inicial', () {
      final bloc = env.selectionBloc();
      expect(bloc.state, isA<PayslipLoadingState>());
      expect(bloc.state.data, isEmpty);
      expect(bloc.state.numeroCadastro, isNull);
      expect(bloc.state.payslipFile.data, isNull);
      bloc.close();
    });

    test('beginLoad sem sessão não faz nada', () async {
      final bloc = env.selectionBloc(withSession: false);
      bloc.beginLoad('M1', mes);
      await drain();
      expect(env.http.requests, isEmpty);
      await bloc.close();
    });

    test('beginLoad filtra os holerites pelo mês selecionado', () async {
      env.stubPayslips('M1', [
        payslipJson(name: 'ago', date: '2026-08-05T00:00:00.000'),
        payslipJson(name: 'jul', date: '2026-07-05T00:00:00.000'),
        payslipJson(name: 'ago-antigo', date: '2025-08-05T00:00:00.000'),
      ]);
      final states = <PayslipSelectionState>[];
      final bloc = env.selectionBloc();
      bloc.stream.listen(states.add);

      bloc.beginLoad('M1', mes);
      await drain();

      expect(env.paths, ['/digitalRepository/documents/M1']);
      expect(states[0], isA<PayslipLoadingState>());
      expect(states[0].numeroCadastro, 'M1');
      final loaded = states[1] as PayslipLoadedState;
      expect(loaded.data.map((e) => e.name), ['ago']);
      expect(loaded.numeroCadastro, 'M1');
      await bloc.close();
    });

    test('falha ao carregar emite LoadFailed', () async {
      env.http.failAll();
      final bloc = env.selectionBloc();
      bloc.beginLoad('M1', mes);
      await drain();
      final failed = bloc.state as PayslipLoadFailedState;
      expect(failed.error, isA<UnknownFailure>());
      expect(failed.numeroCadastro, 'M1');
      expect(failed.props.last, failed.error);
      await bloc.close();
    });

    test('beginDownloadFile baixa o arquivo e resetState volta para carregado', () async {
      env.stubPayslips('M1', [payslipJson(name: 'h.pdf')]);
      env.stubPayslipFile('h.pdf', 'M1');
      final bloc = env.selectionBloc();
      bloc.beginLoad('M1', mes);
      await drain();
      final states = <PayslipSelectionState>[];
      bloc.stream.listen(states.add);

      bloc.beginDownloadFile('h.pdf', 'M1');
      await drain();

      expect(env.paths.last, '/digitalRepository/documents/h.pdf/M1');
      expect(states[0], isA<PayslipLoadingState>());
      expect(states[0].data, hasLength(1));
      final downloaded = states[1] as PayslipFileDownloadedState;
      expect(downloaded.payslipFile.data, pdfBase64);
      expect(downloaded.data, hasLength(1));
      expect(downloaded.numeroCadastro, 'M1');

      bloc.resetState();
      await drain();
      final reset = bloc.state as PayslipLoadedState;
      expect(reset.data, hasLength(1));
      expect(reset.payslipFile.data, isNull);
      expect(reset.numeroCadastro, 'M1');
      await bloc.close();
    });

    test('falha no download emite LoadFailed mantendo a lista', () async {
      env.stubPayslips('M1', [payslipJson(name: 'h.pdf')]);
      final bloc = env.selectionBloc();
      bloc.beginLoad('M1', mes);
      await drain();
      env.http.failAll();

      bloc.beginDownloadFile('h.pdf', 'M1');
      await drain();

      final failed = bloc.state as PayslipLoadFailedState;
      expect(failed.data, hasLength(1));
      expect(failed.error, isA<UnknownFailure>());
      await bloc.close();
    });

    test('eventos e estados comparáveis por valor', () {
      expect(PayslipLoadEvent(condominiumId: 'C1', employeeId: 'E1', selectedMonth: mes),
          PayslipLoadEvent(condominiumId: 'C1', employeeId: 'E1', selectedMonth: mes));
      expect(const PayslipDownloadFileEvent(registrationNumber: 'M1', nameFile: 'h').props,
          ['M1', 'h']);
      expect(const PayslipResetEvent().props, isEmpty);
      final file = PayslipFile();
      expect(PayslipLoadedState(const [], 'M1', file), PayslipLoadedState(const [], 'M1', file));
      expect(PayslipFileDownloadedState(const [], 'M1', file).props, [<Object>[], 'M1', file]);
    });
  });
}
