import 'package:essentials/essentials.dart';
import '../bloc/facedetection/facedetection_bloc.dart';

class FaceDetectionService {
  final FaceDetector faceDetector;
  final FaceDetectionBloc faceBloc;

  // Default tolerance values
  static const double defaultMovementRight = 40;
  static const double defaultMovementLeft = -40;
  static const double defaultMovementTop = -20;
  static const double defaultMovementBottom = 20;

  // Increased tolerance values for liveness validation
  static const double livenessMovementRight = 60;
  static const double livenessMovementLeft = -60;
  static const double livenessMovementTop = -30;
  static const double livenessMovementBottom = 30;

  // Current tolerance values
  double _currentMovementRight = defaultMovementRight;
  double _currentMovementLeft = defaultMovementLeft;
  double _currentMovementTop = defaultMovementTop;
  double _currentMovementBottom = defaultMovementBottom;

  FaceDetectionService({
    required this.faceBloc,
  }) : faceDetector = FaceDetector(
          options: FaceDetectorOptions(
            enableContours: false,
            enableClassification: true,
            performanceMode: FaceDetectorMode.fast,
            enableLandmarks: false,
            minFaceSize: 0.5,
            enableTracking: false,
          ),
        );

  void setLivenessTolerance() {
    _currentMovementRight = livenessMovementRight;
    _currentMovementLeft = livenessMovementLeft;
    _currentMovementTop = livenessMovementTop;
    _currentMovementBottom = livenessMovementBottom;
  }

  void setDefaultTolerance() {
    _currentMovementRight = defaultMovementRight;
    _currentMovementLeft = defaultMovementLeft;
    _currentMovementTop = defaultMovementTop;
    _currentMovementBottom = defaultMovementBottom;
  }

  Future<List<Face>> detectFaces(InputImage inputImage) async {
    return await faceDetector.processImage(inputImage);
  }

  String getCentralizationInstructions(Face oneface, InputImage image) {
    const double movimentFar = 5;
    const double movimentNear = -5;

    if (oneface.headEulerAngleX == null ||
        oneface.headEulerAngleY == null ||
        oneface.headEulerAngleZ == null) {
      return "face_center_position";
    }

    //too far away
    if (image.metadata != null &&
        oneface.boundingBox.size.width < (image.metadata!.size.width) * 0.45) {
      return "face_to_far_away";
    }

    //tilt
    if (oneface.headEulerAngleX! > _currentMovementBottom) {
      return "face_detected_move_bottom";
    }

    if (oneface.headEulerAngleX! < _currentMovementTop) {
      return "face_detected_move_top";
    }

    //pan
    if (oneface.headEulerAngleY! > _currentMovementRight) {
      if (image.metadata?.rotation == InputImageRotation.rotation90deg ||
          image.metadata?.rotation == InputImageRotation.rotation180deg) {
        return "face_detected_move_right";
      } else {
        return "face_detected_move_left";
      }
    }

    //pan
    if (oneface.headEulerAngleY! < _currentMovementLeft) {
      if (image.metadata?.rotation == InputImageRotation.rotation90deg ||
          image.metadata?.rotation == InputImageRotation.rotation180deg) {
        return "face_detected_move_left";
      } else {
        return "face_detected_move_right";
      }
    }

    //yaw
    if (oneface.headEulerAngleZ! > movimentFar ||
        oneface.headEulerAngleZ! < movimentNear) {
      return "face_center_position";
    }

    return '';
  }

  void dispose() {
    faceDetector.close();
  }
}
