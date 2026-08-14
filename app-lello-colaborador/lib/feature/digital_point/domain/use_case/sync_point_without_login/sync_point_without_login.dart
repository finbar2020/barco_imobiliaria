import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:essentials/essentials.dart';

abstract class SyncPointWithoutLoginUsecase
    extends UseCase<void, SyncPointWithoutLoginParam> {}

class SyncPointWithoutLoginParam {
  final DigitalPointEntity digitalPoint;

  SyncPointWithoutLoginParam({
    required this.digitalPoint,
  });
}
