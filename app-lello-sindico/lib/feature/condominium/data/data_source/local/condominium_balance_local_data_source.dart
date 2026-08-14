import 'package:lello/feature/condominium/data/model/condominium_balance_model.dart';

abstract class CondominiumBalanceLocalDataSource {
  Future<CondominiumBalanceModel?> select(String reference);
  Future<CondominiumBalanceModel?> save(CondominiumBalanceModel? model);
}
