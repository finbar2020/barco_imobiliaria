import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance_detail.dart';
import 'package:lello/feature/condominium/domain/use_case/load_condominium_balance_detail/load_condominium_balance_detail.dart';

abstract class CondominiumBalanceDetailRepository {
  Future<Try<CondominiumBalanceDetail>> select(
      LoadCondominiumBalanceDetailParam params);
  Future<Try<CondominiumBalanceDetail?>> selectFromCache(
      LoadCondominiumBalanceDetailParam params);
}
