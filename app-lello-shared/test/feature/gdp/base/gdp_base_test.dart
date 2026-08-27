import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull, Address;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/data/model/address_model.dart';
import 'package:shared_features/feature/gdp/data/model/employee_model.dart';
import 'package:shared_features/feature/gdp/domain/entity/address.dart';
import 'package:shared_features/feature/gdp/domain/entity/condominium.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee_list_filter.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee_status.dart';
import 'package:shared_features/feature/gdp/domain/use_case/get_employee/get_employee.dart';
import 'package:shared_features/feature/gdp/domain/use_case/list_employee/list_employee.dart';
import 'package:shared_features/feature/gdp/presentation/page/gdp_main_page.dart';
import 'package:shared_features/shared_features.dart';

import '../../../helpers/firebase_mocks.dart';
import '../../../helpers/pump_app.dart';
import '../../../helpers/test_container.dart';
import '../vacation/vacation_test_helpers.dart';

/// Objeto "me" mínimo para `CondominiumGDP.fromMe`.
class _Me {
  final String id = 'C1';
  final String name = 'Condomínio';
  final String condominiumId = 'R1';
}

void main() {
  group('AddressModel / EmployeeModel', () {
    test('fromJson, toJson, toEntity e fromEntity completos', () {
      final model = EmployeeModel.fromJson(employeeJson('E1', name: 'Ana'));
      expect(model.id, 'E1');
      expect(model.name, 'Ana');
      expect(model.dob, DateTime(1990, 1, 2));
      expect(model.role, 'Porteiro');
      expect(model.hiringDate, DateTime(2020, 3, 4));
      expect(model.phone, '11999999999');
      expect(model.phone2, '1133333333');
      expect(model.address?.address, 'Rua A');
      expect(model.address?.complement, 'ap 1');
      expect(model.address?.number, '10');
      expect(model.salary, 2500.5);
      expect(model.schooling, 'Médio');
      expect(model.status, 'working');
      expect(model.picture, 'http://x/p.png');

      final json = model.toJson();
      expect(json['hiring_date'], startsWith('2020-03-04'));
      expect((json['address'] as AddressModel).toJson(),
          {'address': 'Rua A', 'complement': 'ap 1', 'number': '10'});

      final entity = model.toEntity();
      expect(entity, isA<Employee>());
      expect(entity.name, 'Ana');
      expect(entity.address, isA<Address>());
      expect(entity.address?.number, '10');
      expect(entity.salary, 2500.5);
      expect(entity.picture, 'http://x/p.png');

      final volta = EmployeeModel.fromEntity(entity)!;
      expect(volta.id, 'E1');
      expect(volta.dob, DateTime(1990, 1, 2));
      expect(volta.address?.complement, 'ap 1');
      expect(volta.status, 'working');
    });

    test('nulos: sem endereço, sem datas e fromEntity(null)', () {
      final model = EmployeeModel.fromJson({'id': 'E2'});
      expect(model.dob, isNull);
      expect(model.hiringDate, isNull);
      expect(model.address, isNull);
      expect(model.toEntity().address, isNull);
      expect(model.toJson()['dob'], isNull);
      expect(EmployeeModel.fromEntity(null), isNull);
      expect(AddressModel.fromEntity(null), isNull);
      expect(EmployeeModel.fromEntity(Employee())!.address, isNull);

      final address = AddressModel(complement: 'c', number: '1')..address = 'a';
      expect(AddressModel.fromJson(address.toJson()).address, 'a');
      final volta = AddressModel.fromEntity(address.toEntity())!;
      expect(volta.complement, 'c');
      expect(volta.number, '1');
    });
  });

  group('entidades base', () {
    test('CondominiumGDP clone e fromMe', () {
      final c = CondominiumGDP(id: '1', name: 'n', reference: 'r');
      final clone = CondominiumGDP.clone(c);
      expect(clone.props, ['1', 'n', 'r']);

      final fromMe = CondominiumGDP.fromMe(_Me());
      expect(fromMe.id, 'C1');
      expect(fromMe.name, 'Condomínio');
      expect(fromMe.reference, 'R1');

      final vazio = CondominiumGDP.fromMe(null);
      expect(vazio.id, '');
      expect(vazio.name, isNull);
      expect(vazio.reference, '');
    });

    test('EmployeeListFilter e EmployeeStatus', () {
      final filter = EmployeeListFilter(
          name: 'a',
          role: 'r',
          salaryFrom: 1,
          salaryTo: 2,
          dobFrom: DateTime(2000),
          status: 's',
          dobTo: DateTime(2001),
          hiringDateTo: DateTime(2002),
          conditionName: 'ativo');
      expect(filter.name, 'a');
      expect(filter.hiringDateFrom, isNull);
      expect(filter.hiringDateTo, DateTime(2002));
      expect(EmployeeStatus.values,
          [EmployeeStatus.working, EmployeeStatus.vacation, EmployeeStatus.dismissed]);
    });
  });

  group('EmployeeRepositoryImpl + data source', () {
    late VacationEnv env;

    setUp(() => env = VacationEnv());

    test('list envia os filtros como query e converte a lista', () async {
      env.stubEmployees([employeeJson('E1', name: 'Ana')]);
      final filter = EmployeeListFilter(
          name: 'An',
          role: 'Porteiro',
          salaryFrom: 100,
          salaryTo: 200,
          dobFrom: DateTime(1990),
          dobTo: DateTime(1991),
          status: 'working',
          conditionName: 'ativo')
        ..hiringDateFrom = DateTime(2020)
        ..hiringDateTo = DateTime(2021);

      final result = await env.employeeRepository.list(
          condominiumId, DataOrigin.remote,
          lastEmployeeId: 'E0', filter: filter);

      expect(result, isA<Success<List<Employee>>>());
      expect(result.getOrElse(() => []).single.name, 'Ana');
      final query = env.http.requests.single.url.queryParameters;
      expect(query['last_employee_id'], 'E0');
      expect(query['name'], 'An');
      expect(query['role'], 'Porteiro');
      expect(query['salary_from'], '100.0');
      expect(query['salary_to'], '200.0');
      expect(query['dob_from'], startsWith('1990-01-01'));
      expect(query['dob_to'], startsWith('1991-01-01'));
      expect(query['hiring_date_from'], startsWith('2020-01-01'));
      expect(query['hiring_date_to'], startsWith('2021-01-01'));
      expect(query['status'], 'working');
      expect(query['condition_name'], 'ativo');
    });

    test('salário zero e filtro nulo não vão na query', () async {
      env.stubEmployees([]);
      await env.employeeRepository.list(condominiumId, DataOrigin.local,
          filter: EmployeeListFilter(salaryFrom: 0, salaryTo: 0));
      var query = env.http.requests.last.url.queryParameters;
      expect(query.containsKey('salary_from'), isFalse);
      expect(query.containsKey('salary_to'), isFalse);

      await env.employeeRepository.list(condominiumId, DataOrigin.local);
      query = env.http.requests.last.url.queryParameters;
      expect(query, isEmpty);
    });

    test('list e get com erro viram Rejection(UnknownFailure)', () async {
      env.http.failAll();
      final list = await env.employeeRepository.list(condominiumId, DataOrigin.remote);
      expect((list as Rejection).get(), isA<UnknownFailure>());
      final get = await env.employeeRepository.get(condominiumId, 'E1');
      expect((get as Rejection).get(), isA<UnknownFailure>());
    });

    test('get devolve o funcionário', () async {
      env.http.on('GET', '$employeesPath/E1', body: employeeJson('E1', name: 'Ana'));
      final result = await env.employeeRepository.get(condominiumId, 'E1');
      expect(result.getOrElse(() => Employee()).name, 'Ana');
    });
  });

  group('use cases base', () {
    late VacationEnv env;

    setUp(() => env = VacationEnv());

    test('ListEmployeeImpl valida o condomínio e delega', () async {
      env.stubEmployees([employeeJson('E1')]);
      final ok = await env.listEmployee.call(ListEmployeeParam(
          condominiumId: condominiumId, origin: DataOrigin.remote));
      expect(ok.getOrElse(() => []), hasLength(1));

      final invalido = await env.listEmployee
          .call(ListEmployeeParam(condominiumId: '', origin: DataOrigin.remote));
      expect((invalido as Rejection).get(), isA<InvalidParamFailure>());
    });

    test('GetEmployeeImpl valida os parâmetros e delega', () async {
      env.http.on('GET', '$employeesPath/E1', body: employeeJson('E1'));
      final ok = await env.getEmployee
          .call(GetEmployeeParam(condominiumId: condominiumId, employeeId: 'E1'));
      expect(ok, isA<Success<Employee>>());

      final semCond = await env.getEmployee
          .call(GetEmployeeParam(condominiumId: '', employeeId: 'E1'));
      expect((semCond as Rejection).get(), isA<InvalidParamFailure>());
      final semFunc = await env.getEmployee
          .call(GetEmployeeParam(condominiumId: condominiumId, employeeId: ''));
      expect((semFunc as Rejection).get(), isA<InvalidParamFailure>());
    });
  });

  group('GdpMainPage', () {
    late RecordingNavigatorObserver observer;

    setUpAll(() async {
      await setUpFakeFirebase();
    });

    setUp(() {
      observer = RecordingNavigatorObserver();
      fakeAnalytics.reset();
    });

    Future<void> pumpMain(WidgetTester tester, AppOriginEnum origin) =>
        pumpPage(
          tester,
          GdpMainPage(appContainer: TestSharedContainer(), appOriginEnum: origin),
          arguments: GdpMainPageArgs(
              appOriginEnum: origin, reference: 'R1', unit: '12'),
          observer: observer,
        );

    Future<void> tapAndBack(WidgetTester tester, String key, String route) async {
      await tester.tap(find.text(key));
      await tester.pumpAndSettle();
      expect(observer.pushedNames.last, route);
      expect(findRoute(route), findsOneWidget);
      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await tester.pumpAndSettle();
    }

    testWidgets('lista os módulos e navega para cada um (síndico)',
        (tester) async {
      await pumpMain(tester, AppOriginEnum.manager);

      expect(find.text('gdp_main_page_title'), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(6));
      await expectLater(find.byType(GdpMainPage),
          matchesGoldenFile('goldens/gdp_main_page.png'));

      await tapAndBack(tester, 'gdp_quick_fix', SharedApplicationRoute.gdpQuickFix);
      await tapAndBack(tester, 'gdp_team', SharedApplicationRoute.gdpEmployeeList);
      await tapAndBack(
          tester, 'gdp_vacation', SharedApplicationRoute.gdpVacationEmployees);
      await tapAndBack(tester, 'gdp_payroll', SharedApplicationRoute.gdppayroll);
      await tapAndBack(tester, 'gdp_payslip', SharedApplicationRoute.gdpPayslipMonth);
      await tapAndBack(
          tester, 'gdp_timesheet', SharedApplicationRoute.gdpTimesheetMenu);

      expect(fakeAnalytics.eventNames, contains('agendar_ferias_acessar'));
      expect(fakeAnalytics.eventNames, hasLength(4));
      expect(fakeAnalytics.events['agendar_ferias_acessar']?['referencia'], 'R1');
      expect(fakeAnalytics.events['agendar_ferias_acessar']?['unidade'], '12');
    });

    testWidgets('origem funcionário usa os eventos do funcionário',
        (tester) async {
      await pumpMain(tester, AppOriginEnum.employee);

      await tapAndBack(
          tester, 'gdp_vacation', SharedApplicationRoute.gdpVacationEmployees);
      await tapAndBack(tester, 'gdp_payroll', SharedApplicationRoute.gdppayroll);
      await tapAndBack(tester, 'gdp_payslip', SharedApplicationRoute.gdpPayslipMonth);
      await tapAndBack(
          tester, 'gdp_timesheet', SharedApplicationRoute.gdpTimesheetMenu);

      expect(fakeAnalytics.eventNames, hasLength(4));
      expect(fakeAnalytics.eventNames, contains('agendar_ferias_acessar'));
    });
  });
}
