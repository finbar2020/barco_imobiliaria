import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_created.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_locked_days.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_params.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/details/vacation_event.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/details/vacation_state.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/employees/vacation_employees_event.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/employees/vacation_employees_state.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_event.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_state.dart';

import '../../../helpers/firebase_mocks.dart';
import 'vacation_test_helpers.dart';

void main() {
  late VacationEnv env;

  setUpAll(() async {
    await setUpFakeFirebase();
  });

  setUp(() {
    env = VacationEnv();
    fakeAnalytics.reset();
  });

  group('VacationGDPBloc', () {
    test('beginLoad carrega férias, parâmetros e dias bloqueados', () async {
      env.stubVacationSuccess();
      final bloc = env.vacationBloc();
      final states = <VacationGDPState>[];
      bloc.stream.listen(states.add);

      expect(bloc.state, const VacationGDPLoadingState(null));
      bloc.beginLoad(employeeId);
      await drain();

      expect(states, hasLength(2));
      expect(states.first, const VacationGDPLoadingState(condominiumId));
      final loaded = states.last as VacationGDPLoadedState;
      expect(loaded.condominiumId, condominiumId);
      expect(loaded.data?.employeeName, 'Fulano de Tal');
      expect(loaded.vacationParams?.qtdInitDays, 1);
      expect(loaded.lockedDays.locked_days, ['01/01/2030']);
      expect(bloc.pendingEmployeeId, employeeId);

      final paths = env.http.requests.map((r) => r.url.path).toList();
      expect(paths, [vacationPath, periodsPath, lockedDaysPath]);
      // Dias bloqueados de hoje até ~3 anos à frente.
      final query = env.http.requests.last.url.queryParameters;
      expect(query['start_date'], yyyyMMdd(DateTime.now()));
      expect(query['end_date'],
          yyyyMMdd(DateTime.now().add(const Duration(days: 1095))));
      await bloc.close();
    });

    test('falha em qualquer chamada emite VacationGDPLoadFailedState',
        () async {
      env.stubVacationSuccess();
      env.http.on('GET', lockedDaysPath, status: 500, body: {'title': 'x'});
      final bloc = env.vacationBloc();
      final states = <VacationGDPState>[];
      bloc.stream.listen(states.add);

      bloc.beginLoad(employeeId);
      await drain();

      expect(states.last, isA<VacationGDPLoadFailedState>());
      final failed = states.last as VacationGDPLoadFailedState;
      expect(failed.condominiumId, condominiumId);
      expect(failed.error, isA<UnknownFailure>());
      await bloc.close();
    });

    test('sem sessão o beginLoad só guarda o funcionário pendente', () async {
      final bloc = env.vacationBloc(withSession: false);
      final states = <VacationGDPState>[];
      bloc.stream.listen(states.add);

      bloc.beginLoad(employeeId);
      await drain();

      expect(states, isEmpty);
      expect(bloc.pendingEmployeeId, employeeId);
      expect(env.http.requests, isEmpty);
      await bloc.close();
    });

    /// Defeito: `getVacationLockedDays` adiciona um `GetLockedDaysEvent` que
    /// não tem handler registrado no bloc — em modo debug o `add` lança
    /// StateError e em release o evento é ignorado.
    test('getVacationLockedDays lança StateError (evento sem handler)', () {
      final bloc = env.vacationBloc();
      expect(
          () => bloc.getVacationLockedDays(
              employeeId, DateTime(2030), DateTime(2031)),
          throwsStateError);
      expect(bloc.pendingEmployeeId, employeeId);
      expect(() => bloc.add(const VacationGDPPeriodEvent()), throwsStateError);
      bloc.close();
    });

    /// Defeito: `vacationParams` nunca é preenchido pelo bloc, logo
    /// `getVacationParams()` sempre lança ao fazer `!` em null.
    test('getVacationParams lança porque vacationParams nunca é preenchido',
        () {
      final bloc = env.vacationBloc();
      expect(bloc.vacationParams, isNull);
      expect(bloc.vacationLockedDays, isNull);
      expect(() => bloc.getVacationParams(), throwsA(isA<TypeError>()));
      bloc.close();
    });

    test('eventos e estados comparam por props', () {
      expect(
          const VacationGDPLoadEvent(condominiumId: 'C', employeeId: 'E'),
          const VacationGDPLoadEvent(condominiumId: 'C', employeeId: 'E'));
      expect(const VacationGDPLoadEvent(condominiumId: 'C', employeeId: 'E'),
          isNot(const VacationGDPLoadEvent(condominiumId: 'C', employeeId: 'X')));
      expect(const VacationGDPPeriodEvent().props, isEmpty);
      final d = DateTime(2030);
      expect(GetLockedDaysEvent(employeeId: 'E', startDate: d, endDate: d).props,
          ['E', d, d]);

      final locked = VacationLockedDays();
      final params = VacationParams(periods: [], qtdInitDays: 1);
      final data = Vacation();
      expect(VacationGDPLoadedState(data, 'C', params, locked),
          VacationGDPLoadedState(data, 'C', params, locked));
      expect(VacationGDPLoadedState(data, 'C', params, locked).props,
          ['C', data, params, locked]);
      expect(VacationGDPLockedDaysState([locked], d, d, 'C').props,
          ['C', [locked], d, d]);
      expect(const VacationGDPLoadFailedState('C').props, ['C', null]);
      expect(const VacationGDPLoadingState('C'),
          isNot(const VacationGDPLoadingState('D')));
    });
  });

  group('VacationEmployeesBloc', () {
    final ana = employeeJson('E1', name: 'Ana');
    final bia = employeeJson('E2', name: 'Bia');

    test('com sessão carrega a lista na construção (cache + remoto)',
        () async {
      env.stubEmployees([ana, bia]);
      final bloc = env.employeesBloc();
      final states = <VacationEmployeesState>[];
      bloc.stream.listen(states.add);

      expect(bloc.state, const VacationEmployeesLoadingState([], '', ''));
      await drain();

      expect(states, hasLength(2));
      final loading = states.first as VacationEmployeesLoadingState;
      // O "cache" (DataOrigin.local) também vai ao remoto e já traz dados.
      expect(loading.data.map((e) => e.name), ['Ana', 'Bia']);
      expect(loading.condominiumId, condominiumId);
      final loaded = states.last as VacationEmployeesLoadedState;
      expect(loaded.data.map((e) => e.name), ['Ana', 'Bia']);
      expect(loaded.donePaging, isFalse);
      expect(loaded.query, '');
      expect(bloc.loadedCache, isTrue);

      expect(env.http.requests, hasLength(2));
      final query = env.http.requests.first.url.queryParameters;
      expect(query['condition_name'], 'ativo');
      // O chopper omite parâmetros vazios.
      expect(query.containsKey('name'), isFalse);
      expect(query.containsKey('last_employee_id'), isFalse);
      await bloc.close();
    });

    test('lista vazia marca donePaging e falha vira LoadFailedState',
        () async {
      env.stubEmployees([]);
      final bloc = env.employeesBloc();
      await drain();
      expect(bloc.state, isA<VacationEmployeesLoadedState>());
      expect((bloc.state as VacationEmployeesLoadedState).donePaging, isTrue);
      await bloc.close();

      env.http.failAll();
      final bloc2 = env.employeesBloc();
      await drain();
      expect(bloc2.state, isA<VacationEmployeesLoadFailedState>());
      final failed = bloc2.state as VacationEmployeesLoadFailedState;
      expect(failed.data, isEmpty);
      expect(failed.error, isA<UnknownFailure>());
      await bloc2.close();
    });

    test('sem sessão não carrega e as ações respeitam o estado inicial',
        () async {
      final bloc = env.employeesBloc(withSession: false);
      final states = <VacationEmployeesState>[];
      bloc.stream.listen(states.add);

      // Estado inicial é Loading: refresh e próxima página são ignorados e
      // a busca fica pendente.
      bloc.beginRefresh();
      bloc.beginLoadNextPage();
      bloc.beginSearch('Jo');
      await drain();

      expect(states, isEmpty);
      expect(bloc.pendingSearch, 'Jo');
      expect(env.http.requests, isEmpty);
      await bloc.close();
    });

    test('beginSearch busca por nome e resolve as buscas pendentes',
        () async {
      env.stubEmployees([ana, bia]);
      final bloc = env.employeesBloc();
      await drain();
      env.http.requests.clear();

      env.stubEmployees([ana]);
      final states = <VacationEmployeesState>[];
      bloc.stream.listen(states.add);
      bloc.beginSearch('An');
      // Enquanto busca, uma segunda busca fica pendente.
      await bloc.stream
          .firstWhere((s) => s is VacationEmployeesSearchingState);
      bloc.beginSearch('B');
      expect(bloc.pendingSearch, 'B');
      await drain();

      expect(states.first, isA<VacationEmployeesSearchingState>());
      expect(states.first.query, 'An');
      expect(states.first.data, hasLength(2));
      expect(states[1], isA<VacationEmployeesLoadedState>());
      expect(states[1].query, 'An');
      expect(states[1].data.map((e) => e.name), ['Ana']);
      // A busca pendente "B" é disparada (e repetida uma vez até ser limpa).
      expect(states.last, isA<VacationEmployeesLoadedState>());
      expect(states.last.query, 'B');
      expect(bloc.pendingSearch, isNull);

      final names = env.http.requests.map((r) => r.url.queryParameters['name']);
      expect(names, ['An', 'B', 'B']);
      expect(env.http.requests.first.url.queryParameters.containsKey('condition_name'),
          isFalse);
      await bloc.close();
    });

    /// Defeito: a busca pendente registrada durante o carregamento inicial só
    /// é disparada quando outra busca termina (`_handlePendingSearch` só roda
    /// em `_mapSearch`), então o texto digitado durante o loading é perdido.
    test('busca pendente durante o carregamento inicial não é disparada',
        () async {
      env.stubEmployees([ana]);
      final bloc = env.employeesBloc();
      bloc.beginSearch('Zé');
      await drain();

      expect(bloc.state, isA<VacationEmployeesLoadedState>());
      expect(bloc.state.query, '');
      expect(bloc.pendingSearch, 'Zé');
      expect(env.http.requests, hasLength(2));
      await bloc.close();
    });

    test('falha na busca emite LoadFailedState com a query', () async {
      env.stubEmployees([ana]);
      final bloc = env.employeesBloc();
      await drain();

      env.http.failAll();
      bloc.beginSearch('x');
      await drain();

      expect(bloc.state, isA<VacationEmployeesLoadFailedState>());
      expect(bloc.state.query, 'x');
      expect(bloc.state.data.map((e) => e.name), ['Ana']);
      await bloc.close();
    });

    test('beginLoadNextPage pagina a partir do último id', () async {
      env.stubEmployees([ana, bia]);
      final bloc = env.employeesBloc();
      await drain();
      env.http.requests.clear();

      final states = <VacationEmployeesState>[];
      bloc.stream.listen(states.add);
      env.stubEmployees([employeeJson('E3', name: 'Caio')]);
      bloc.beginLoadNextPage();
      await drain();

      expect(states.first, isA<VacationEmployeesPagingState>());
      final loaded = states.last as VacationEmployeesLoadedState;
      expect(loaded.data.map((e) => e.name), ['Ana', 'Bia', 'Caio']);
      expect(loaded.donePaging, isFalse);
      expect(env.http.requests.single.url.queryParameters['last_employee_id'],
          'E2');

      // Página vazia encerra a paginação e o próximo pedido é ignorado.
      env.stubEmployees([]);
      bloc.beginLoadNextPage();
      await drain();
      expect((bloc.state as VacationEmployeesLoadedState).donePaging, isTrue);
      env.http.requests.clear();
      bloc.beginLoadNextPage();
      await drain();
      expect(env.http.requests, isEmpty);
      await bloc.close();
    });

    test('falha na paginação emite PageFailedState mantendo os dados',
        () async {
      env.stubEmployees([ana]);
      final bloc = env.employeesBloc();
      await drain();

      env.http.failAll();
      bloc.beginLoadNextPage();
      await drain();

      expect(bloc.state, isA<VacationEmployeesPageFailedState>());
      final failed = bloc.state as VacationEmployeesPageFailedState;
      expect(failed.data.map((e) => e.name), ['Ana']);
      expect(failed.error, isA<UnknownFailure>());
      await bloc.close();
    });

    test('beginRefresh recarrega sem repetir o cache', () async {
      env.stubEmployees([ana]);
      final bloc = env.employeesBloc();
      await drain();
      env.http.requests.clear();

      env.stubEmployees([ana, bia]);
      bloc.beginRefresh();
      await drain();

      expect(env.http.requests, hasLength(1));
      expect(bloc.state.data.map((e) => e.name), ['Ana', 'Bia']);
      await bloc.close();
    });

    test('eventos e estados comparam por props', () {
      expect(const VacationEmployeesLoadEvent(condominiumId: 'C'),
          const VacationEmployeesLoadEvent(condominiumId: 'C'));
      expect(const VacationEmployeesNextPageEvent().props, isEmpty);
      expect(const VacationEmployeesSearchEvent(query: 'q').props, ['q']);

      final data = <Employee>[];
      final err = UnknownFailure('x');
      expect(VacationEmployeesLoadFailedState(data, 'q', 'C', err).props,
          [data, 'q', 'C', err]);
      expect(VacationEmployeesPageFailedState(data, 'q', 'C', err).props,
          [data, 'q', 'C', err]);
      expect(VacationEmployeesLoadedState(data, 'q', 'C', true).props,
          [data, 'q', 'C', true]);
      expect(VacationEmployeesSearchingState(data, 'q', 'C'),
          VacationEmployeesSearchingState(data, 'q', 'C'));
      expect(VacationEmployeesPagingState(data, 'q', 'C'),
          isNot(VacationEmployeesPagingState(data, 'z', 'C')));
    });
  });

  group('ScheduleVacationBloc', () {
    final created = VacationCreated(
        employeeId: employeeId,
        employeeRegistrationNumber: 'M123',
        numbersUnitVacation: 1);

    test('sucesso emite Loading e Loaded e loga o evento do síndico',
        () async {
      env.http.on('POST', periodsPath, body: vacationCreatedJson());
      final bloc = env.scheduleBloc(origin: AppOriginEnum.manager);
      final states = <ScheduleVacationState>[];
      bloc.stream.listen(states.add);

      expect(bloc.state, const ScheduleVacationLoadedState(null, null));
      bloc.createScheduledVacation(employeeId, created);
      await drain();

      expect(states, [
        const ScheduleVacationLoadingState(null, condominiumId),
        const ScheduleVacationLoadedState(null, condominiumId),
      ]);
      expect(env.http.requests.single.url.path, periodsPath);
      expect(fakeAnalytics.eventNames, contains('agendar_ferias_finalizado'));
      expect(fakeAnalytics.events['agendar_ferias_finalizado']?['referencia'],
          'R1');
      await bloc.close();
    });

    test('origem funcionário loga o evento do funcionário', () async {
      env.http.on('POST', periodsPath, body: vacationCreatedJson());
      final bloc = env.scheduleBloc(origin: AppOriginEnum.employee);
      bloc.createScheduledVacation(employeeId, created);
      await drain();
      expect(bloc.state, const ScheduleVacationLoadedState(null, condominiumId));
      expect(fakeAnalytics.eventNames, contains('agendar_ferias_finalizado'));
      await bloc.close();
    });

    test('origem proprietário não loga analytics', () async {
      env.http.on('POST', periodsPath, body: vacationCreatedJson());
      final bloc = env.scheduleBloc(origin: AppOriginEnum.owner);
      bloc.createScheduledVacation(employeeId, created);
      await drain();
      expect(bloc.state, isA<ScheduleVacationLoadedState>());
      expect(fakeAnalytics.eventNames, isEmpty);
      await bloc.close();
    });

    test('erro 406 emite LoadFailedState com KnownFailure', () async {
      env.http.on('POST', periodsPath, status: 406, body: {
        'status': 406,
        'title': 'Conflito',
        'detail': 'Período já agendado',
      });
      final bloc = env.scheduleBloc();
      bloc.createScheduledVacation(employeeId, created);
      await drain();

      expect(bloc.state, isA<ScheduleVacationLoadFailedState>());
      final failed = bloc.state as ScheduleVacationLoadFailedState;
      expect(failed.error, isA<KnownFailure>());
      expect(failed.condominiumId, condominiumId);
      expect(fakeAnalytics.eventNames, isEmpty);
      await bloc.close();
    });

    test('sem sessão o condomínio vazio é rejeitado pelo use case', () async {
      final bloc = env.scheduleBloc(withSession: false);
      bloc.createScheduledVacation(employeeId, created);
      await drain();

      expect(bloc.state, isA<ScheduleVacationLoadFailedState>());
      expect((bloc.state as ScheduleVacationLoadFailedState).error,
          isA<InvalidParamFailure>());
      expect(bloc.state.condominiumId, '');
      expect(env.http.requests, isEmpty);
      await bloc.close();
    });

    test('eventos e estados comparam por props', () {
      expect(
          CreateScheduledVacationEvent(
                  employeeId: 'E', vacationCreated: created)
              .props,
          ['E', created]);
      final err = UnknownFailure('x');
      expect(ScheduleVacationLoadFailedState(null, 'C', err).props,
          [null, 'C', err]);
      expect(const ScheduleVacationLoadingState(null, 'C'),
          isNot(const ScheduleVacationLoadedState(null, 'C')));
    });
  });
}
