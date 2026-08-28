// Helpers compartilhados pelos testes de employee, payslip, payroll e
// quick_fix (GDP). Monta a cadeia REAL de funcionários do pacote
// (EmployeeApi via chopper -> data source -> repositório -> use cases) em cima
// do `FakeHttp`, além de uma sessão falsa e JSONs prontos.
import 'dart:async';

import 'package:chopper/chopper.dart' as chopper;
import 'package:essentials/essentials.dart' hide isNull, isNotNull, Address;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/data/data_source/remote/employee_api.dart';
import 'package:shared_features/feature/gdp/data/data_source/remote/employee_remote_data_source_impl.dart';
import 'package:shared_features/feature/gdp/data/repository/employee_repository_impl.dart';
import 'package:shared_features/feature/gdp/domain/entity/address.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/domain/use_case/get_employee/get_employee_impl.dart';
import 'package:shared_features/feature/gdp/domain/use_case/list_employee/list_employee_impl.dart';
import 'package:shared_features/shared_features.dart';

import '../../../helpers/fake_http.dart';
import '../../../helpers/pump_app.dart';
import '../../../helpers/test_container.dart';

const condominiumId = 'C1';
const employeeId = 'E1';

/// Sessão falsa: os blocs do GDP só leem `condominiumId`, `unitId` e
/// `condominiumReference`.
class FakeSession implements SharedSession {
  FakeSession({
    this.condominiumId = 'C1',
    this.condominiumReference = 'R1',
    this.userId = 'U1',
    this.unitId = '101',
  });

  @override
  final String condominiumId;
  @override
  final String condominiumReference;
  @override
  final String userId;
  @override
  final String unitId;
}

String get employeesPath => '/condominiums/$condominiumId/employees';

Map<String, dynamic> employeeJson(
  String id, {
  String name = 'Fulano',
  String? role = 'Porteiro',
  String status = 'ativo',
  double? salary = 2500.5,
  bool full = true,
}) =>
    {
      'id': id,
      'name': name,
      'role': role,
      'status': status,
      'salary': salary,
      if (full) ...{
        'dob': '1990-01-02T00:00:00.000',
        'hiring_date': '2020-03-04T00:00:00.000',
        'phone': '11999999999',
        'phone2': '1133333333',
        'address': {'address': 'Rua A', 'complement': 'ap 1', 'number': '10'},
        'schooling': 'Médio',
        'picture': 'http://x/p.png',
      },
    };

Employee employee({
  String id = employeeId,
  String name = 'Fulano de Tal',
  String? role = 'Porteiro',
  bool full = false,
}) {
  final e = Employee()
    ..id = id
    ..name = name
    ..role = role;
  if (full) {
    e
      ..dob = DateTime(1990, 1, 2)
      ..hiringDate = DateTime(2020, 3, 4)
      ..phone = '11999999999'
      ..phone2 = '1133333333'
      ..address = (Address()
        ..address = 'Rua A'
        ..complement = 'ap 1'
        ..number = '10')
      ..salary = 2500.5
      ..schooling = 'Médio'
      ..status = 'ativo'
      ..picture = 'http://x/p.png';
  }
  return e;
}

/// Ambiente base: HTTP falso + cadeia real de funcionários.
class GdpEnv {
  GdpEnv({SharedSession? session}) : session = session ?? FakeSession() {
    client = buildChopperClient(http);
    employeeApi = EmployeeApi.create(client);
    employeeRepository = EmployeeRepositoryImpl(
        remoteDataSource: EmployeeRemoteDataSourceImpl(api: employeeApi));
    listEmployee = ListEmployeeImpl(repository: employeeRepository);
    getEmployee = GetEmployeeImpl(repository: employeeRepository);
  }

  final http = FakeHttp();
  final SharedSession session;
  late final chopper.ChopperClient client;
  late final EmployeeApi employeeApi;
  late final EmployeeRepositoryImpl employeeRepository;
  late final ListEmployeeImpl listEmployee;
  late final GetEmployeeImpl getEmployee;

  void stubEmployees(List<Map<String, dynamic>> employees) {
    http.on('GET', employeesPath, body: employees);
  }

  void stubEmployee(Map<String, dynamic> employee) {
    http.on('GET', '$employeesPath/${employee['id']}', body: employee);
  }

  /// Container com o validador real; registre os blocs por cima.
  TestSharedContainer container() =>
      TestSharedContainer()..register<Validator>(ValidatorImpl());

  List<String> get paths => http.requests.map((r) => r.url.path).toList();
}

/// Espera a fila de eventos assíncronos (HTTP falso é assíncrono).
Future<void> drain([int times = 40]) => pumpEventQueue(times: times);

/// Deixa os blocs já criados terminarem o carregamento dentro da zona fake
/// do `testWidgets` (antes de montar a página sob teste).
Future<void> settleBlocs(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pumpAndSettle();
}

/// Página hospedeira: monta [page] como uma rota empilhada em cima de uma
/// tela base, para que `Navigator.pop` da página sob teste tenha para onde
/// voltar. Devolve depois de a página estar montada.
Future<void> pumpPushed(
  WidgetTester tester,
  Widget page, {
  Object? arguments,
  NavigatorObserver? observer,
  Size surface = const Size(400, 800),
  bool settle = true,
  Map<String, WidgetBuilder> routes = const {},
}) async {
  await pumpPage(
    tester,
    const Scaffold(key: Key('host'), body: Text('host')),
    observer: observer,
    surface: surface,
    routes: {'/pushed': (_) => page, ...routes},
  );
  tester
      .state<NavigatorState>(find.byType(Navigator))
      .pushNamed('/pushed', arguments: arguments);
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
    await tester.pump();
  }
}

/// Executa [body] numa zona guardada e devolve os erros não tratados
/// (defeitos que estouram dentro de handlers de bloc/listeners).
Future<List<Object>> collectUncaught(FutureOr<void> Function() body) async {
  final errors = <Object>[];
  await runZonedGuarded(() async => await body(), (e, s) => errors.add(e));
  return errors;
}
