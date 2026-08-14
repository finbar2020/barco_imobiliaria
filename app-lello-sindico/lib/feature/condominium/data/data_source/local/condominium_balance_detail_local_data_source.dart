import 'package:lello/feature/condominium/data/model/condominium_balance_detail_model.dart';

abstract class CondominiumBalanceDetailLocalDataSource {
  Future<CondominiumBalanceDetailModel?> select(String reference);
  Future<CondominiumBalanceDetailModel?> save(
      CondominiumBalanceDetailModel? model);
}
