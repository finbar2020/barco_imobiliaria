import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance.dart';
import 'package:lello/feature/condominium/domain/use_case/load_condominium_balance/load_condominium_balance.dart';

abstract class CondominiumBalanceRepository {
  Future<Try<CondominiumBalance?>> select(CondominiumBalanceParam params);
  Future<Try<CondominiumBalance?>> selectFromCache(
      CondominiumBalanceParam params);
}
