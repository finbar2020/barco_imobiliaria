import 'package:lib_facedetection/lib_facedetection.dart';

enum DigitalPointCaptureTypeEnum {
  manual,
  automatic,
  lifeValidation,
}

class DigitalPointCaptureTypeEnumUtils {
  static DigitalPointCaptureTypeEnum fromTypeCapture(
      {required TypeCaptureEnum typeCaptureEnum}) {
    if (typeCaptureEnum.isAutomatic) {
      return DigitalPointCaptureTypeEnum.automatic;
    }
    if (typeCaptureEnum.isManual) {
      return DigitalPointCaptureTypeEnum.manual;
    }
    if (typeCaptureEnum.isLifeValidation) {
      return DigitalPointCaptureTypeEnum.lifeValidation;
    }
    return DigitalPointCaptureTypeEnum.manual;
  }
}
