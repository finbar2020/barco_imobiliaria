import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:essentials/essentials.dart';

abstract class SavePointUsecase
    extends UseCase<DigitalPointEntity, SavePointParam> {}

class SavePointParam {
  final DigitalPointEntity model;
  final String condoId;
  final String meId;

  SavePointParam({
    required this.model,
    required this.condoId,
    required this.meId,
  });
}
