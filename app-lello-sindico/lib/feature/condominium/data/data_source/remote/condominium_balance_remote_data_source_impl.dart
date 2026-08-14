import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/data/data_source/remote/condominium_balance_api.dart';
import 'package:lello/feature/condominium/data/model/condominium_balance_detail_model.dart';
import 'package:lello/feature/condominium/data/model/condominium_balance_model.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance_detail_filter.dart';

import 'condominium_balance_remote_data_source.dart';

class CondominiumBalanceRemoteDataSourceImpl
    extends CondominiumBalanceRemoteDataSource {
  final CondominiumBalanceApi api;
  CondominiumBalanceRemoteDataSourceImpl({required this.api});

  @override
  Future<CondominiumBalanceModel> select(String condominiumId) async {
    final response = await api.get(condominiumId);
    return ApiMapper.map(
        response, (json) => CondominiumBalanceModel.fromJson(json));
  }

  @override
  Future<CondominiumBalanceDetailModel> selectDetail(
      String condominiumId, CondominiumBalanceDetailFilter? filter) async {
    final response = await api.getDetail(condominiumId,
        startDate: filter?.startDate,
        endDate: filter?.endDate,
        orderByDate: filter?.orderByDate,
        orderByCount: filter?.orderByCount,
        onlyReceita: filter?.onlyReceita,
        onlyDespesa: filter?.onlyDespesa,
        selectCount: filter?.selectCount);

    return ApiMapper.map(
        response, (json) => CondominiumBalanceDetailModel.fromJson(json));
  }
}
