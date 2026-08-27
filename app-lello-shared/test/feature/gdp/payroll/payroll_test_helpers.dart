// Helpers dos testes de folha de pagamento (gdp/payroll): cadeia real
// PayrollApi/PayrollEntryApi -> data sources -> repositórios -> use cases.
import 'package:shared_features/feature/gdp/payroll/data/data_source/payroll/payroll_api.dart';
import 'package:shared_features/feature/gdp/payroll/data/data_source/payroll/payroll_remote_data_source_impl.dart';
import 'package:shared_features/feature/gdp/payroll/data/data_source/payroll_entry/payroll_entry_api.dart';
import 'package:shared_features/feature/gdp/payroll/data/data_source/payroll_entry/payroll_entry_remote_data_source_impl.dart';
import 'package:shared_features/feature/gdp/payroll/data/repository/payroll_entry_repository_impl.dart';
import 'package:shared_features/feature/gdp/payroll/data/repository/payroll_repository_impl.dart';
import 'package:shared_features/feature/gdp/payroll/domain/entity/payroll.dart';
import 'package:shared_features/feature/gdp/payroll/domain/entity/payroll_entry.dart';
import 'package:shared_features/feature/gdp/payroll/domain/use_case/get_payroll/get_payroll_impl.dart';
import 'package:shared_features/feature/gdp/payroll/domain/use_case/list_payroll/list_payroll_impl.dart';
import 'package:shared_features/feature/gdp/payroll/domain/use_case/list_payroll_entry/list_payroll_entry_impl.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/bloc/payroll/payroll_bloc.dart';
import 'package:shared_features/feature/gdp/payroll/presentation/bloc/payroll_entry/payroll_entry_bloc.dart';

import '../employee/gdp_rest_test_helpers.dart';

export '../employee/gdp_rest_test_helpers.dart';

String get payrollsPath => '/condominiums/$condominiumId/payrolls';

Map<String, dynamic> payrollJson({
  String? period = '2026-08-01T00:00:00.000',
  String? type = 'Mensal',
  double? value = 10000.5,
  double? discounts = 1500.25,
  double? balance = 8500.25,
}) =>
    {
      'period': period,
      'type': type,
      'value': value,
      'discounts': discounts,
      'balance': balance,
    };

Map<String, dynamic> payrollEntryJson({
  String id = 'PE1',
  String title = 'Salário',
  double? value = 3000.0,
}) =>
    {'id': id, 'title': title, 'value': value};

Payroll payroll({
  DateTime? period,
  String? type = 'Mensal',
  double? value = 10000.5,
  double? discounts = 1500.25,
  double? balance = 8500.25,
}) =>
    Payroll()
      ..period = period ?? DateTime(2026, 8)
      ..type = type
      ..value = value
      ..discounts = discounts
      ..balance = balance;

PayrollEntry payrollEntry({String? id = 'PE1', String? title = 'Salário', double? value = 3000}) =>
    PayrollEntry()
      ..id = id
      ..title = title
      ..value = value;

class PayrollEnv extends GdpEnv {
  PayrollEnv({super.session}) {
    payrollApi = PayrollApi.create(client);
    payrollDataSource = PayrollRemoteDataSourceImpl(api: payrollApi);
    payrollRepository = PayrollRepositoryImpl(remoteDataSource: payrollDataSource);
    getPayroll = GetPayrollImpl(repository: payrollRepository);
    listPayroll = ListPayrollImpl(repository: payrollRepository);

    entryApi = PayrollEntryApi.create(client);
    entryDataSource = PayrollEntryRemoteDataSourceImpl(api: entryApi);
    entryRepository = PayrollEntryRepositoryImpl(remoteDataSource: entryDataSource);
    listPayrollEntry = ListPayrollEntryImpl(repository: entryRepository);
  }

  late final PayrollApi payrollApi;
  late final PayrollRemoteDataSourceImpl payrollDataSource;
  late final PayrollRepositoryImpl payrollRepository;
  late final GetPayrollImpl getPayroll;
  late final ListPayrollImpl listPayroll;

  late final PayrollEntryApi entryApi;
  late final PayrollEntryRemoteDataSourceImpl entryDataSource;
  late final PayrollEntryRepositoryImpl entryRepository;
  late final ListPayrollEntryImpl listPayrollEntry;

  void stubPayrolls(List<Map<String, dynamic>> payrolls) {
    http.on('GET', payrollsPath, body: payrolls);
  }

  void stubPayroll(String period, Map<String, dynamic> payroll) {
    http.on('GET', '$payrollsPath/$period', body: payroll);
  }

  void stubEntries(String period, List<Map<String, dynamic>> entries) {
    http.on('GET', '$payrollsPath/$period/entries', body: entries);
  }

  PayrollBloc payrollBloc({bool withSession = true}) => PayrollBloc(
      sessionBloc: withSession ? session : null,
      getPayroll: getPayroll,
      listPayroll: listPayroll);

  PayrollEntryBloc entryBloc({bool withSession = true}) => PayrollEntryBloc(
      sessionBloc: withSession ? session : null, listPayrollEntry: listPayrollEntry);
}
