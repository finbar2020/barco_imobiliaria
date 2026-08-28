// Helpers compartilhados pelos testes da feature de férias (GDP).
//
// Monta a cadeia REAL do pacote (VacationApi/EmployeeApi via chopper ->
// data sources -> repositórios -> use cases -> blocs) em cima do `FakeHttp`,
// e oferece JSONs prontos no formato dos `*.g.dart`.
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/data/data_source/remote/employee_api.dart';
import 'package:shared_features/feature/gdp/data/data_source/remote/employee_remote_data_source_impl.dart';
import 'package:shared_features/feature/gdp/data/repository/employee_repository_impl.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/domain/use_case/get_employee/get_employee_impl.dart';
import 'package:shared_features/feature/gdp/domain/use_case/list_employee/list_employee_impl.dart';
import 'package:shared_features/feature/gdp/vacation/data/data_source/vacation_api.dart';
import 'package:shared_features/feature/gdp/vacation/data/data_source/vacation_remote_data_source_impl.dart';
import 'package:shared_features/feature/gdp/vacation/data/repository/vacation_repository_impl.dart';
import 'package:shared_features/feature/gdp/vacation/domain/use_case/get_vacation/get_vacation_impl.dart';
import 'package:shared_features/feature/gdp/vacation/domain/use_case/get_vacation_locked_days/get_vacation_locked_days_impl.dart';
import 'package:shared_features/feature/gdp/vacation/domain/use_case/get_vacation_period/get_vacation_period_impl.dart';
import 'package:shared_features/feature/gdp/vacation/domain/use_case/schedule_vacation/schedule_vacation_impl.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/details/vacation_bloc.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/employees/vacation_employees_bloc.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_bloc.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/page/vacation_page.dart';
import 'package:shared_features/shared_features.dart';

import '../../../helpers/fake_http.dart';
import '../../../helpers/pump_app.dart';
import '../../../helpers/test_container.dart';

const condominiumId = 'C1';
const employeeId = 'E1';

/// Sessão falsa: as classes de férias só usam `condominiumId` e
/// `condominiumReference`.
class FakeSession implements SharedSession {
  FakeSession({
    this.condominiumId = 'C1',
    this.condominiumReference = 'R1',
    this.userId = 'U1',
    this.unitId = 'UN1',
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

/// Validador falso para a `ScheduleVacationPage`.
class FakeValidator extends Fake implements Validator {
  @override
  String? validateRequired(String? text) =>
      (text == null || text.isEmpty) ? 'validation_required' : null;
}

String ddMMyyyy(DateTime d) => DateFormat('dd/MM/yyyy').format(d);

String yyyyMMdd(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

DateTime get hoje {
  final n = DateTime.now();
  return DateTime(n.year, n.month, n.day);
}

Map<String, dynamic> employeeJson(String id, {String name = 'Fulano'}) => {
      'id': id,
      'name': name,
      'dob': '1990-01-02T00:00:00.000',
      'role': 'Porteiro',
      'hiring_date': '2020-03-04T00:00:00.000',
      'phone': '11999999999',
      'phone2': '1133333333',
      'address': {'address': 'Rua A', 'complement': 'ap 1', 'number': '10'},
      'salary': 2500.5,
      'schooling': 'Médio',
      'status': 'working',
      'picture': 'http://x/p.png',
    };

/// JSON de `VacationModel`. Por padrão sem férias agendadas (formulário
/// editável). Passe [vacationStartDate]/[vacationEndDate] para o modo
/// "somente leitura".
Map<String, dynamic> vacationJson({
  String? vacationStartDate,
  String? vacationEndDate,
  String advance13 = '',
  int scheduledDays = 0,
  int salaryAllowance = 0,
  int numbersUnitVacation = 0,
  String? acquisitivePeriodStart,
  String? acquisitivePeriodEnd,
  List<Map<String, dynamic>>? scheduledVacations,
  bool includeEmployee = true,
}) =>
    {
      if (includeEmployee) 'employee': employeeJson(employeeId),
      'employee_id': employeeId,
      'company': 7,
      'employee_type': 1,
      'employee_registration_number': 'M123',
      'acquisitive_period_start_date':
          acquisitivePeriodStart ?? ddMMyyyy(hoje.subtract(Duration(days: 365))),
      'acquisitive_period_end_date': acquisitivePeriodEnd ?? ddMMyyyy(hoje),
      'reference': 'R1',
      'employee_name': 'Fulano de Tal',
      'admission_date': '04/03/2020',
      'dead_line': '30/12/2027',
      'allowance_days': 30.0,
      'number_absences': 2.0,
      'vacation_start_date': vacationStartDate,
      'vacation_end_date': vacationEndDate,
      'scheduled_days': scheduledDays,
      'salary_allowance': salaryAllowance,
      'advance13': advance13,
      'total_vacation': 1,
      'numbers_unit_vacation': numbersUnitVacation,
      if (scheduledVacations != null) 'scheduled_vacations': scheduledVacations,
    };

/// Parâmetros de período: 1, 2 ou 3 períodos. O `getIntervals` só devolve
/// algo quando `intervals.length > periodsNumber`, por isso cada período tem
/// um intervalo a mais do que o número de períodos.
Map<String, dynamic> vacationParamsJson({int initDays = 1}) => {
      'gdp_vacation_init_days': initDays,
      'gdp_vacation_periods': <dynamic>[
        {
          'gdp_period_vacation': 1,
          'gdp_period_amount': <dynamic>[
            {'days': [30], 'allowence': 0},
            {'days': [20], 'allowence': 10},
          ],
        },
        {
          'gdp_period_vacation': 2,
          'gdp_period_amount': <dynamic>[
            {'days': [20, 10], 'allowence': 0},
            {'days': [15, 15], 'allowence': 0},
            {'days': [10, 10], 'allowence': 10},
          ],
        },
        {
          'gdp_period_vacation': 3,
          'gdp_period_amount': <dynamic>[
            {'days': [14, 8, 8], 'allowence': 0},
            {'days': [10, 10, 10], 'allowence': 0},
            {'days': [12, 10, 8], 'allowence': 0},
            {'days': [15, 10, 5], 'allowence': 0},
          ],
        },
      ],
    };

Map<String, dynamic> lockedDaysJson([List<String>? days]) => {
      'locked_days': days ?? ['01/01/2030'],
    };

Map<String, dynamic> vacationCreatedJson() => {
      'employee_id': employeeId,
      'company': 7,
      'employee_registration_number': 'M123',
      'vacation_scheduled_periods': <dynamic>[
        {
          'start_date': '2030-01-10T00:00:00.000',
          'scheduled_days': 30,
          'total_vacation': 1,
        },
      ],
      'salary_allowance': 0,
      'advance13': 'N',
      'numbers_unit_vacation': 1,
    };

String get vacationPath =>
    '/condominiums/$condominiumId/employees/$employeeId/vacations';
String get periodsPath => '$vacationPath/periods';
String get lockedDaysPath => '$vacationPath/holidays/';
String get employeesPath => '/condominiums/$condominiumId/employees';

/// Ambiente de férias: HTTP falso + cadeia real de classes do pacote.
class VacationEnv {
  VacationEnv({SharedSession? session, AppOriginEnum? origin})
      : session = session ?? FakeSession(),
        appOrigin = origin ?? AppOriginEnum.manager {
    final client = buildChopperClient(http);
    vacationApi = VacationApi.create(client);
    vacationRepository = VacationRepositoryImpl(
        remoteDataSource: VacationRemoteDataSourceImpl(api: vacationApi));
    getVacation = GetVacationImpl(repository: vacationRepository);
    getVacationPeriod = GetVacationPeriodImpl(repository: vacationRepository);
    getLockedDays = GetLockedDaysImpl(repository: vacationRepository);
    scheduleVacation = ScheduleVacationImpl(repository: vacationRepository);

    employeeApi = EmployeeApi.create(client);
    employeeRepository = EmployeeRepositoryImpl(
        remoteDataSource: EmployeeRemoteDataSourceImpl(api: employeeApi));
    listEmployee = ListEmployeeImpl(repository: employeeRepository);
    getEmployee = GetEmployeeImpl(repository: employeeRepository);
  }

  final http = FakeHttp();
  final SharedSession? session;
  final AppOriginEnum appOrigin;

  late final VacationApi vacationApi;
  late final VacationRepositoryImpl vacationRepository;
  late final GetVacationImpl getVacation;
  late final GetVacationPeriodImpl getVacationPeriod;
  late final GetLockedDaysImpl getLockedDays;
  late final ScheduleVacationImpl scheduleVacation;

  late final EmployeeApi employeeApi;
  late final EmployeeRepositoryImpl employeeRepository;
  late final ListEmployeeImpl listEmployee;
  late final GetEmployeeImpl getEmployee;

  /// Respostas padrão de sucesso para a tela de férias de um funcionário.
  void stubVacationSuccess({
    Map<String, dynamic>? vacation,
    Map<String, dynamic>? params,
    Map<String, dynamic>? lockedDays,
  }) {
    http.on('GET', vacationPath, body: vacation ?? vacationJson());
    http.on('GET', periodsPath, body: params ?? vacationParamsJson());
    http.on('GET', lockedDaysPath, body: lockedDays ?? lockedDaysJson());
  }

  void stubEmployees(List<Map<String, dynamic>> employees) {
    http.on('GET', employeesPath, body: employees);
  }

  VacationGDPBloc vacationBloc({bool withSession = true}) => VacationGDPBloc(
        sessionBloc: withSession ? session : null,
        getVacation: getVacation,
        getVacationPeriod: getVacationPeriod,
        getLockedDays: getLockedDays,
      );

  VacationEmployeesBloc employeesBloc({bool withSession = true}) =>
      VacationEmployeesBloc(
          sessionBloc: withSession ? session : null,
          listEmployee: listEmployee);

  ScheduleVacationBloc scheduleBloc(
          {bool withSession = true, AppOriginEnum? origin}) =>
      ScheduleVacationBloc(
        scheduleVacation: scheduleVacation,
        sessionBloc: withSession ? session : null,
        appOriginEnum: origin ?? appOrigin,
      );

  /// Container com os blocs registrados como singletons (um por teste).
  TestSharedContainer container({
    VacationGDPBloc? vacation,
    VacationEmployeesBloc? employees,
    ScheduleVacationBloc? schedule,
  }) {
    final c = TestSharedContainer();
    if (vacation != null) c.register<VacationGDPBloc>(vacation);
    if (employees != null) c.register<VacationEmployeesBloc>(employees);
    if (schedule != null) c.register<ScheduleVacationBloc>(schedule);
    c.register<Validator>(FakeValidator());
    return c;
  }
}

Employee employee({String id = employeeId, String name = 'Fulano de Tal'}) =>
    Employee()
      ..id = id
      ..name = name
      ..role = 'Porteiro';

/// Configuração de um período já preenchida (para as telas de resumo).
PeriodConfig periodConfig({
  DateTime? start,
  int? days = 30,
  double allowance = 0,
  String? allow13 = 'N',
  String? formatedAllow13 = 'no',
}) =>
    PeriodConfig(
      start: start ?? DateTime(2030, 1, 10),
      days: days,
      allowanceValue: allowance,
      formatedAllow13: formatedAllow13,
      allow13Value: allow13,
      employeeId: employeeId,
      employeeRegistrationNumber: 'M123',
      employeeCompany: 7,
      admissionDate: '04/03/2020',
      employeeName: 'Fulano de Tal',
      periodAquisitive: '01/01/2029 a 31/12/2029 ',
    );

/// Rota da página de férias dentro do Navigator aninhado dos testes.
const vacationRouteName = '/vacation';

/// Rotas NOMEADAS empurradas pela tela sob teste (ignora as rotas iniciais
/// `/`, a rota da própria página e rotas sem nome: menus, diálogos, avisos).
List<String> pushedRoutes(RecordingNavigatorObserver observer) => observer
    .pushedNames
    .where((n) =>
        n != null &&
        n != '/' &&
        n != '/flushbarRoute' &&
        n != pageRouteName &&
        n != vacationRouteName)
    .cast<String>()
    .toList();

/// Caminho do POST de agendamento: o id na URL é o do funcionário (a matrícula
/// vai no corpo, em `employee_registration_number`).
String get createVacationPath =>
    '/condominiums/$condominiumId/employees/$employeeId/vacations/periods';

/// Espera a fila de eventos assíncronos (HTTP falso é assíncrono).
Future<void> drain([int times = 40]) => pumpEventQueue(times: times);
