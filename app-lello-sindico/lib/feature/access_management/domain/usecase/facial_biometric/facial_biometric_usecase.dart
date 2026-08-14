import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/access_management/domain/entity/access_control_register_facial_response.dart';

abstract class FacialBiometricUsecase
    extends UseCase<AccessControlRegisterFacialResponse, FacialBiometricParam> {
}

class FacialBiometricParam {
  final File file;
  FacialBiometricParam({
    required this.file,
  });
}
