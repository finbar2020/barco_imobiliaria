import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_check_max_value_param.dart';

abstract class GetResinCheckMaxValueUsecase
    extends UseCase<ResinCheckMaxValueParam, GetResinCheckMaxValueParams> {}

class GetResinCheckMaxValueParams {
  final String condominiumId;
  final String type;
  final double value;

  GetResinCheckMaxValueParams({
    required this.condominiumId,
    required this.type,
    required this.value,
  });
}
