import 'package:essentials/essentials.dart';
import 'package:intl/intl.dart';
import 'package:shared_features/feature/gdp/payroll/data/data_source/payroll_entry/payroll_entry_api.dart';
import 'package:shared_features/feature/gdp/payroll/data/data_source/payroll_entry/payroll_entry_remote_data_source.dart';
import 'package:shared_features/feature/gdp/payroll/data/model/payroll_entry_model.dart';

class PayrollEntryRemoteDataSourceImpl extends PayrollEntryRemoteDataSource {
  final PayrollEntryApi api;

  PayrollEntryRemoteDataSourceImpl({required this.api});

  @override
  Future<List<PayrollEntryModel>> list(
      String condominiumId, DateTime period) async {
    final format = DateFormat("yyyy-MM");
    final response = await api.get(condominiumId, format.format(period));
    return ApiMapper.mapList(
        response, (json) => PayrollEntryModel.fromJson(json));
  }
}
