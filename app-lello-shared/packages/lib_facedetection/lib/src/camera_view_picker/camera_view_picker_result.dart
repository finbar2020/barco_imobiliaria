import 'package:camera/camera.dart';
import 'package:lib_facedetection/src/domain/enum/type_capture_enum.dart';

class CameraViewPickerResult {
  final TypeCaptureEnum captureEnum;
  XFile? file;

  CameraViewPickerResult({
    required this.captureEnum,
    this.file,
  });
}
