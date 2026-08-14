import 'package:essentials/essentials.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/payroll/data/data_source/payroll/payroll_api.dart';
import 'package:lello/feature/payroll/data/data_source/payroll/payroll_remote_data_source.dart';
import 'package:lello/feature/payroll/data/model/payroll_model.dart';

class PayrollRemoteDataSourceImpl extends PayrollRemoteDataSource {
  final PayrollApi api;

  PayrollRemoteDataSourceImpl({required this.api});

  @override
  Future<PayrollModel> select(String condominiumId, DateTime period) async {
    final format = DateFormat("yyyy-MM");
    final response = await api.get(condominiumId, format.format(period));
    return ApiMapper.map(response, (json) => PayrollModel.fromJson(json));
  }

  @override
  Future<List<PayrollModel>> list(String condominiumId) async {
    final response = await api.list(condominiumId);
    return ApiMapper.mapList(response, (json) => PayrollModel.fromJson(json));
  }
}
