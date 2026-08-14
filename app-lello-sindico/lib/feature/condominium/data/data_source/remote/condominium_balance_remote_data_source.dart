import 'package:lello/feature/condominium/data/model/condominium_balance_detail_model.dart';
import 'package:lello/feature/condominium/data/model/condominium_balance_model.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance_detail_filter.dart';

abstract class CondominiumBalanceRemoteDataSource {
  Future<CondominiumBalanceModel> select(String condominiumId);
  Future<CondominiumBalanceDetailModel> selectDetail(
      String condominiumId, CondominiumBalanceDetailFilter? filter);
}
