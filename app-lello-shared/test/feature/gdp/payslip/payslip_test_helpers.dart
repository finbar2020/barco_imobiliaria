// Helpers dos testes de holerite (gdp/payslip): cadeia real
// PayslipApi -> data source -> repositório -> use cases sobre o FakeHttp.
import 'package:shared_features/feature/gdp/payslip/data/data_source/payslip_api.dart';
import 'package:shared_features/feature/gdp/payslip/data/data_source/payslip_remote_data_source_impl.dart';
import 'package:shared_features/feature/gdp/payslip/data/repository/payslip_repository_impl.dart';
import 'package:shared_features/feature/gdp/payslip/domain/entity/payslip.dart';
import 'package:shared_features/feature/gdp/payslip/domain/use_case/get_payslips/get_payslip_impl.dart';
import 'package:shared_features/feature/gdp/payslip/domain/use_case/get_payslips_file/get_payslip_file_impl.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/bloc/employees/payslip_employees_bloc.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/bloc/selection/payslip_selection_bloc.dart';

import '../employee/gdp_rest_test_helpers.dart';

export '../employee/gdp_rest_test_helpers.dart';

/// "%PDF-1.4" em base64.
const pdfBase64 = 'JVBERi0xLjQ=';

Map<String, dynamic> payslipJson({
  String name = 'holerite.pdf',
  String description = 'Holerite Agosto',
  String type = 'pdf',
  String? date = '2026-08-05T00:00:00.000',
}) =>
    {
      'name': name,
      'description': description,
      'type': type,
      'processing_date': date,
    };

Map<String, dynamic> payslipFileJson({
  String id = 'F1',
  String name = 'holerite.pdf',
  String data = pdfBase64,
}) =>
    {'id': id, 'name': name, 'type': 'pdf', 'data': data};

Payslip payslip({String name = 'h.pdf', String description = 'Holerite', DateTime? date}) =>
    Payslip(name: name, description: description, type: 'pdf', processingDate: date ?? DateTime(2026, 8, 5));

class PayslipEnv extends GdpEnv {
  PayslipEnv({super.session}) {
    api = PayslipApi.create(client);
    dataSource = PayslipRemoteDataSourceImpl(api: api);
    repository = PayslipRepositoryImpl(remoteDataSource: dataSource);
    getPayslip = GetPayslipImpl(repository: repository);
    getPayslipFile = GetPayslipFileImpl(repository: repository);
  }

  late final PayslipApi api;
  late final PayslipRemoteDataSourceImpl dataSource;
  late final PayslipRepositoryImpl repository;
  late final GetPayslipImpl getPayslip;
  late final GetPayslipFileImpl getPayslipFile;

  void stubPayslips(String registration, List<Map<String, dynamic>> payslips) {
    http.on('GET', '/digitalRepository/documents/$registration', body: payslips);
  }

  void stubPayslipFile(String nameFile, String registration,
      {Map<String, dynamic>? body}) {
    http.on('GET', '/digitalRepository/documents/$nameFile/$registration',
        body: body ?? payslipFileJson(name: nameFile));
  }

  PayslipEmployeesBloc employeesBloc({bool withSession = true}) =>
      PayslipEmployeesBloc(
          sessionBloc: withSession ? session : null, listEmployee: listEmployee);

  PayslipSelectionBloc selectionBloc({bool withSession = true}) =>
      PayslipSelectionBloc(
          sessionBloc: withSession ? session : null,
          getPayslip: getPayslip,
          getPayslipFile: getPayslipFile);
}
