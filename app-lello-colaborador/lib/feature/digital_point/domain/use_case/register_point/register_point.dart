import 'dart:io';

import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:essentials/essentials.dart';

abstract class RegisterPointUsecase
    extends UseCase<DigitalPointEntity, RegisterPointParam> {}

class RegisterPointParam {
  final String condoId;
  final String meId;
  final DigitalPointEntity digitalPoint;
  final File file;

  RegisterPointParam({
    required this.condoId,
    required this.meId,
    required this.digitalPoint,
    required this.file,
  });
}
