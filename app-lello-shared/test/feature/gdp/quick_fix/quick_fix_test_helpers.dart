// Helpers dos testes do "Resolva Rápido" (gdp/quick_fix): cadeia real
// EmployeeReportApi -> data source -> repositório -> use case -> blocs.
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:shared_features/feature/gdp/domain/entity/condominium.dart';
import 'package:shared_features/feature/gdp/quick_fix/data/data_source/remote/employee_report_api.dart';
import 'package:shared_features/feature/gdp/quick_fix/data/data_source/remote/employee_report_remote_data_source_impl.dart';
import 'package:shared_features/feature/gdp/quick_fix/data/repository/employee_report_repository_impl.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/use_case/get_report/get_employee_report_impl.dart';
import 'package:shared_features/feature/gdp/quick_fix/presentation/bloc/quick_fix/quick_fix_bloc.dart';
import 'package:shared_features/feature/gdp/quick_fix/presentation/bloc/report/quick_fix_report_bloc.dart';

import '../employee/gdp_rest_test_helpers.dart';

export '../employee/gdp_rest_test_helpers.dart';

String reportPath(String employee) =>
    '/condominiums/$condominiumId/employee/$employee/reports';

CondominiumGDP condominium() =>
    CondominiumGDP(id: condominiumId, name: 'Condomínio X', reference: 'R1');

Map<String, dynamic> reportItemJson(String description, Object? value) =>
    {'description': description, 'value': value};

Map<String, dynamic> reportJson({
  String? type = 'vacation',
  Map<String, dynamic>? employee,
  bool includeEmployee = true,
  List<Map<String, dynamic>>? items,
  String? stabilityDescription = 'Gestante',
  String? stabilityStart = '2026-01-10T00:00:00.000',
  String? stabilityEnd = '2026-06-10T00:00:00.000',
}) =>
    {
      'type': type,
      'employee': includeEmployee ? (employee ?? employeeJson('E1', name: 'Ana')) : null,
      'items': items ??
          [reportItemJson('Férias', 1234.5), reportItemJson('1/3 de férias', '411.5')],
      'stability_description': stabilityDescription,
      'stability_start': stabilityStart,
      'stability_end': stabilityEnd,
    };

class QuickFixEnv extends GdpEnv {
  QuickFixEnv({super.session}) {
    reportApi = EmployeeReportApi.create(client);
    reportDataSource = EmployeeReportRemoteDataSourceImpl(api: reportApi);
    reportRepository = EmployeeReportRepositoryImpl(remoteDataSource: reportDataSource);
    getEmployeeReport = GetEmployeeReportImpl(repository: reportRepository);
  }

  late final EmployeeReportApi reportApi;
  late final EmployeeReportRemoteDataSourceImpl reportDataSource;
  late final EmployeeReportRepositoryImpl reportRepository;
  late final GetEmployeeReportImpl getEmployeeReport;

  void stubReport(String employee, Map<String, dynamic> report) {
    http.on('GET', reportPath(employee), body: report);
  }

  QuickFixBloc quickFixBloc(
          {bool withSession = true, AppOriginEnum origin = AppOriginEnum.manager}) =>
      QuickFixBloc(
          sessionBloc: withSession ? session : null,
          listEmployee: listEmployee,
          appOriginEnum: origin);

  QuickFixReportBloc reportBloc(
          {bool withSession = true, AppOriginEnum origin = AppOriginEnum.manager}) =>
      QuickFixReportBloc(
          condominiumId: condominium(),
          getEmployeeReport: getEmployeeReport,
          appOriginEnum: origin,
          sessionBloc: withSession ? session : null);
}
