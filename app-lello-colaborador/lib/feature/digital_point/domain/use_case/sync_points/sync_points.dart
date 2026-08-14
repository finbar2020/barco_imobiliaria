import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:essentials/essentials.dart';

abstract class SyncPointsUsecase
    extends UseCase<List<DigitalPointEntity>, SyncPointsParam> {}

class SyncPointsParam {
  final String condoId;
  final String meId;
  final List<DigitalPointEntity> digitalPoints;

  SyncPointsParam({
    required this.condoId,
    required this.meId,
    required this.digitalPoints,
  });
}
