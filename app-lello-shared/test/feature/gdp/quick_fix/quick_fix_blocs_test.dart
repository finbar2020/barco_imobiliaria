import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull, Address;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/entity/employee_report_filter.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/entity/employee_report_type.dart';
import 'package:shared_features/feature/gdp/quick_fix/presentation/bloc/quick_fix/quick_fix_event.dart';
import 'package:shared_features/feature/gdp/quick_fix/presentation/bloc/quick_fix/quick_fix_state.dart';
import 'package:shared_features/feature/gdp/quick_fix/presentation/bloc/report/quick_fix_report_event.dart';
import 'package:shared_features/feature/gdp/quick_fix/presentation/bloc/report/quick_fix_report_state.dart';

import '../../../helpers/firebase_mocks.dart';
import 'quick_fix_test_helpers.dart';

void main() {
  late QuickFixEnv env;

  setUpAll(() async {
    await setUpFakeFirebase();
  });

  setUp(() {
    env = QuickFixEnv();
    fakeAnalytics.reset();
  });

  group('QuickFixBloc', () {
    test('sem sessão fica carregando sem dados', () async {
      final bloc = env.quickFixBloc(withSession: false);
      await drain();
      expect(bloc.state, isA<QuickFixLoadingState>());
      expect(bloc.state.data, isEmpty);
      expect(bloc.state.condominiumId, isNull);
      expect(env.http.requests, isEmpty);
      await bloc.close();
    });

    test('com sessão lista os funcionários ativos e loga analytics (síndico)', () async {
      env.stubEmployees([employeeJson('E1', name: 'Ana')]);
      final states = <QuickFixState>[];
      final bloc = env.quickFixBloc();
      bloc.stream.listen(states.add);
      await drain();

      expect(env.paths, [employeesPath]);
      expect(env.http.requests.single.url.queryParameters['condition_name'], 'ativo');
      expect(states[0], isA<QuickFixLoadingState>());
      expect(states[0].condominiumId, 'C1');
      final loaded = states[1] as QuickFixLoadedState;
      expect(loaded.data.single.name, 'Ana');
      expect(fakeAnalytics.eventNames, ['resolva_rapido_acessar']);
      expect(fakeAnalytics.events['resolva_rapido_acessar']?['referencia'], 'R1');
      expect(fakeAnalytics.events['resolva_rapido_acessar']?['unidade'], '101');
      await bloc.close();
    });

    test('origem funcionário loga o evento equivalente', () async {
      env.stubEmployees([]);
      final bloc = env.quickFixBloc(origin: AppOriginEnum.employee);
      await drain();
      expect(fakeAnalytics.eventNames, ['resolva_rapido_acessar']);
      await bloc.close();
    });

    test('falha emite LoadFailed e beginLoad tenta de novo', () async {
      env.http.failAll();
      final bloc = env.quickFixBloc();
      await drain();
      final failed = bloc.state as QuickFixLoadFailedState;
      expect(failed.error, isA<UnknownFailure>());
      expect(failed.props.last, failed.error);
      expect(fakeAnalytics.eventNames, isEmpty);

      env.stubEmployees([employeeJson('E1', name: 'Ana')]);
      bloc.beginLoad();
      await drain();
      expect(bloc.state, isA<QuickFixLoadedState>());
      expect(bloc.state.data, hasLength(1));

      // carregando: beginLoad é ignorado
      // ignore: invalid_use_of_visible_for_testing_member
      bloc.emit(QuickFixLoadingState(bloc.state.data, 'C1'));
      env.http.requests.clear();
      bloc.beginLoad();
      await drain();
      expect(env.http.requests, isEmpty);
      await bloc.close();
    });

    test('eventos comparáveis por valor', () {
      expect(const QuickFixLoadEvent(condominiumId: 'C1'),
          const QuickFixLoadEvent(condominiumId: 'C1'));
      expect(const QuickFixLoadEvent(condominiumId: 'C1').props, ['C1']);
      expect(QuickFixLoadingState(null, null).data, isEmpty);
    });
  });

  group('QuickFixReportBloc', () {
    test('ao nascer sem filtro emite LoadFailed("no_filter")', () async {
      final bloc = env.reportBloc();
      expect(bloc.state, isA<QuickFixReportLoadingState>());
      expect(bloc.state.props, [null, null, null]);
      await drain();
      final failed = bloc.state as QuickFixReportLoadFailedState;
      expect(failed.error, isA<UnknownFailure>());
      expect(failed.error.error, 'no_filter');
      expect(failed.condominium?.id, 'C1');
      expect(failed.filter, isNull);
      expect(env.http.requests, isEmpty);
      await bloc.close();
    });

    test('filtro sem tipo de relatório também falha com no_filter', () async {
      final bloc = env.reportBloc();
      await drain();
      bloc.beginLoad(EmployeeReportFilter(employee: employee()));
      await drain();
      final failed = bloc.state as QuickFixReportLoadFailedState;
      expect(failed.error.error, 'no_filter');
      expect(failed.filter?.employee?.id, 'E1');
      expect(env.http.requests, isEmpty);
      await bloc.close();
    });

    test('beginLoad busca o relatório e loga analytics com o tipo', () async {
      env.stubReport('E1', reportJson());
      final bloc = env.reportBloc();
      await drain();
      final states = <QuickFixReportState>[];
      bloc.stream.listen(states.add);
      final filter = EmployeeReportFilter(
          employee: employee(), reportType: EmployeeReportType.vacation);

      bloc.beginLoad(filter);
      await drain();

      expect(env.http.requests.single.url.queryParameters['report_type'], 'vacation');
      expect(states[0], isA<QuickFixReportLoadingState>());
      final loaded = states[1] as QuickFixReportLoadedState;
      expect(loaded.data?.items, hasLength(2));
      expect(loaded.filter, same(filter));
      expect(loaded.condominium?.name, 'Condomínio X');
      expect(fakeAnalytics.eventNames, ['resolva_rapido_finalizado']);
      expect(fakeAnalytics.events['resolva_rapido_finalizado']?['tipo'], 'Férias');
      expect(fakeAnalytics.events['resolva_rapido_finalizado']?['referencia'], 'R1');
      await bloc.close();
    });

    test('rescisão com origem funcionário e sem sessão', () async {
      env.stubReport('E1', reportJson(type: 'termination'));
      final bloc = env.reportBloc(origin: AppOriginEnum.employee, withSession: false);
      await drain();
      bloc.beginLoad(EmployeeReportFilter(
          employee: employee(), reportType: EmployeeReportType.termination));
      await drain();
      expect(bloc.state, isA<QuickFixReportLoadedState>());
      expect(fakeAnalytics.events['resolva_rapido_finalizado']?['tipo'], 'Rescisão');
      expect(fakeAnalytics.events['resolva_rapido_finalizado']?.containsKey('referencia'),
          isFalse);
      await bloc.close();
    });

    test('falha na api emite LoadFailed com o filtro', () async {
      env.http.failAll();
      final bloc = env.reportBloc();
      await drain();
      final filter = EmployeeReportFilter(
          employee: employee(), reportType: EmployeeReportType.vacation);
      bloc.beginLoad(filter);
      await drain();
      final failed = bloc.state as QuickFixReportLoadFailedState;
      expect(failed.error, isA<UnknownFailure>());
      expect(failed.filter, same(filter));
      expect(fakeAnalytics.eventNames, isEmpty);
      await bloc.close();
    });

    test('eventos e estados comparáveis por valor', () {
      final c = condominium();
      expect(QuickFixReportLoadEvent(condominium: c), QuickFixReportLoadEvent(condominium: c));
      expect(QuickFixReportLoadEvent(condominium: c).props, [c, null]);
      expect(const QuickFixReportLoadingState(null, null).filter, isNull);
    });
  });
}
