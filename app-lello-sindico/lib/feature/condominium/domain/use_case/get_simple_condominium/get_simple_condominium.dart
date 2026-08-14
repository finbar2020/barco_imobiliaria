import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_simple.dart';

abstract class GetSimpleCondominiumUsecase
    extends UseCase<CondominiumSimple?, GetSimpleCondominiumParams> {}

class GetSimpleCondominiumParams {
  final String id;

  GetSimpleCondominiumParams({
    required this.id,
  });
}
