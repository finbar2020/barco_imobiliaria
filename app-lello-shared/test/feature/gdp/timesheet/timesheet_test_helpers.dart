// Helpers locais dos testes do espelho de ponto (gdp/timesheet).
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:shared_features/feature/gdp/timesheet/data/data_source/timesheet_api.dart';
import 'package:shared_features/feature/gdp/timesheet/data/data_source/timesheet_remote_data_source_impl.dart';
import 'package:shared_features/feature/gdp/timesheet/data/repository/timesheet_repository_impl.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/get_report_day/get_report_day_impl.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/insert_timesheet_event/insert_timesheet_event_impl.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/list_signature/list_signature_impl.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/list_timesheet/list_timesheet_impl.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/list_timesheet_employee/list_timesheet_employee_impl.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/request_timesheet/request_timesheet_impl.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/sign_timesheet/sign_timesheet_impl.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_list/timesheet_list_bloc.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_menu/timesheet_menu_bloc.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_signatures/timesheet_signatures_bloc.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../../helpers/fake_http.dart';

/// Sessão falsa com os membros usados pelos blocs do espelho de ponto.
class FakeSharedSession implements SharedSession {
  FakeSharedSession({
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

/// Hoje sem hora, igual ao `today` usado pelos blocs e páginas.
DateTime get hoje =>
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

String isoDia(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}T00:00:00';

Map<String, dynamic> employeeJson({
  String id = 'E1',
  String name = 'Maria Silva',
  String? role = 'PORTEIRO',
}) =>
    {'id': id, 'name': name, 'role': role, 'status': 'ATIVO'};

Map<String, dynamic> timesheetJson({
  Map<String, dynamic>? employee,
  DateTime? date,
  List<String>? time = const ['08:00', '12:00', '13:00', '17:00'],
  List<String>? events,
  Map<String, dynamic>? eventControl,
  DateTime? monthClosing,
  String statusDay = 'PRESENTE',
}) =>
    {
      'employee': employee ?? employeeJson(),
      'date': isoDia(date ?? hoje),
      'time': time,
      'schedules': ['08:00', '17:00'],
      'justifications': <String>[],
      'comments': 'ok',
      'signature': null,
      'events': events,
      'event_control': eventControl,
      'lunch_hours': 60,
      'worked_hours': 480,
      'extra_hours50': 0,
      'extra_hours60': 0,
      'extra_hours75': 0,
      'extra_hours80': 0,
      'extra_hours100': 0,
      'extra_hours140': 0,
      'extra_hours200': 0,
      'late_hours': 0,
      'early_departure_hours': 0,
      'status_day': statusDay,
      'month_closing': isoDia(monthClosing ?? DateTime(hoje.year, hoje.month, 1)),
    };

Map<String, dynamic> eventJson({
  String id = 'EV1',
  String typeEvent = 'ABONO',
  DateTime? effectiveDate,
}) =>
    {
      'id': id,
      'registration_number': 'E1',
      'reference': 'R1',
      'minutes': 0,
      'created_by': 'U1',
      'flag_processed': false,
      'type_event': typeEvent,
      'effective_date': isoDia(effectiveDate ?? hoje),
      'process_date': null,
      'created_date': '2026-08-01T10:00:00',
      'changed_date': null,
    };

Map<String, dynamic> signatureJson({
  int id = 1,
  Map<String, dynamic>? employee,
  bool approved = false,
}) =>
    {
      'id': id,
      'employee': employee ?? employeeJson(),
      'signature_date_time': null,
      'period_date': '2026-08-01T00:00:00',
      'approved_flag': approved,
      'type_signature': 'MENSAL',
    };

Map<String, dynamic> reportDayJson({
  int total = 10,
  int present = 6,
  int dayOff = 1,
  int vacation = 1,
  int unmarked = 1,
  int shiftNotStarted = 1,
  int attestation = 0,
}) =>
    {
      'total_amount': total,
      'present_amount': present,
      'day_off_amount': dayOff,
      'vacation_amount': vacation,
      'unmarked_amount': unmarked,
      'shift_not_started_amount': shiftNotStarted,
      'attestation_amount': attestation,
      'clearance_amount': 0,
      'extra_hours': 3,
    };

/// Pilha real (api chopper -> data source -> repositório -> use cases -> blocs)
/// ligada a um [FakeHttp].
class TimesheetStack {
  TimesheetStack() {
    api = TimesheetGDPApi.create(buildChopperClient(http));
    dataSource = TimesheetGDPRemoteDataSourceImpl(api: api);
    repository = TimesheetGDPRepositoryImpl(remoteDataSource: dataSource);
  }

  final FakeHttp http = FakeHttp();
  late final TimesheetGDPApi api;
  late final TimesheetGDPRemoteDataSourceImpl dataSource;
  late final TimesheetGDPRepositoryImpl repository;

  TimesheetMenuBloc menuBloc({SharedSession? session}) => TimesheetMenuBloc(
        sessionBloc: session,
        listTimesheetEmployee: ListTimesheetEmployeeImpl(repository: repository),
        getReportDay: GetReportDayImpl(repository: repository),
        requestTimesheet: RequestTimesheetImpl(repository: repository),
      );

  TimesheetListBloc listBloc({
    SharedSession? session,
    AppOriginEnum origin = AppOriginEnum.manager,
  }) =>
      TimesheetListBloc(
        sessionBloc: session,
        listTimesheet: ListTimesheetImpl(repository: repository),
        insertTimesheetEvent: InsertTimesheetEventImpl(repository: repository),
        appOriginEnum: origin,
      );

  TimesheetSignaturesBloc signaturesBloc({
    SharedSession? session,
    AppOriginEnum origin = AppOriginEnum.manager,
  }) =>
      TimesheetSignaturesBloc(
        sessionBloc: session,
        listSignature: ListSignatureImpl(repository: repository),
        signTimesheet: SignTimesheetImpl(repository: repository),
        appOriginEnum: origin,
      );

  /// Cadastra respostas de sucesso padrão para todas as rotas do condomínio.
  void happyPath({String condominiumId = 'C1', List<Object>? timesheets}) {
    http.on('GET', '/timesheet/report/day/$condominiumId',
        body: reportDayJson());
    http.on('GET', '/timesheet/employees/$condominiumId', body: [
      employeeJson(),
      employeeJson(id: 'E2', name: 'Joao Souza', role: null),
    ]);
    http.on('GET', '/timesheet/references/$condominiumId',
        body: timesheets ?? [timesheetJson()]);
    http.on('GET', '/timesheet/signatures/$condominiumId', body: [
      signatureJson(),
      signatureJson(id: 2, employee: employeeJson(id: 'E2', name: 'Joao Souza')),
    ]);
    http.on('PUT', '/timesheet/signatures/$condominiumId',
        body: [signatureJson(approved: true)]);
    http.on('POST', '/timesheet/event/$condominiumId', body: eventJson());
    http.on('POST', '/timesheet/request/$condominiumId', body: {});
  }
}
