import 'package:essentials/essentials.dart';
import 'package:intl/intl.dart';
import 'package:morar/feature/accountability/data/data_source/accountability_api.dart';
import 'package:morar/feature/accountability/data/data_source/accountability_remote_data_source.dart';
import 'package:morar/feature/accountability/data/model/accountability_model.dart';
import 'package:morar/feature/accountability/data/model/accountability_period_model.dart';

class AccountabilityRemoteDataSourceImpl
    extends AccountabilityRemoteDataSource {
  final AccountabilityApi api;

  AccountabilityRemoteDataSourceImpl({required this.api});

  @override
  Future<AccountabilityModel> select(
      String condominiumId, DateTime period) async {
    final dateFormat = DateFormat("yyyy-MM");
    final response =
        await api.get(condominiumId, dateFormat.format(period).toString());
    return ApiMapper.map(
        response, (json) => AccountabilityModel.fromJson(json));
  }

  @override
  Future<List<AccountabilityPeriodModel>> getPeriod(
      String condominiumId) async {
    final response = await api.getPeriod(condominiumId);
    return ApiMapper.mapList(
        response, (json) => AccountabilityPeriodModel.fromJson(json));
  }
}
