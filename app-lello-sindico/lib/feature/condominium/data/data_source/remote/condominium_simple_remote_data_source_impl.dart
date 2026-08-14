import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/data/data_source/remote/condominium_balance_api.dart';
import 'package:lello/feature/condominium/data/data_source/remote/condominium_simple_remote_data_source.dart';
import 'package:lello/feature/condominium/data/model/condominium_simple_model.dart';

class CondominiumSimpleRemoteDataSourceImpl
    implements CondominiumSimpleRemoteDataSource {
  final CondominiumBalanceApi api;

  CondominiumSimpleRemoteDataSourceImpl({required this.api});

  @override
  Future<CondominiumSimpleModel> getSimple({
    required String condominiumId,
  }) async {
    final response = await api.getCondominiumSimple(condominiumId);
    return ApiMapper.map(
      response,
      (json) => CondominiumSimpleModel.fromJson(json),
    );
  }
}
