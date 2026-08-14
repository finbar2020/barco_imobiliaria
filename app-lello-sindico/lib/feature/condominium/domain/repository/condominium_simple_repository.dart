import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/use_case/get_simple_condominium/get_simple_condominium.dart';

import '../entity/condominium_simple.dart';

abstract class CondominiumSimpleRepository {
  Future<Try<CondominiumSimple>> getSimpleCondominium({
    required GetSimpleCondominiumParams params,
  });
}
