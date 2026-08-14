import 'package:essentials/essentials.dart';
import 'package:flutter/services.dart';
import 'package:lib_facedetection/lib_facedetection.dart';

class LifeValidationService {
  final FaceDetectionBloc faceBloc;
  final int qteActionsLifeValidation;
  final bool isRandomActionsLifeValidation;
  final List<LifeValidationTypeEnum>? actionsLifeValidation;

  late List<LifeValidationTypeEnum> listEnumActions;
  List<LifeValidationTypeEnum> passedEnumActions = [];

  bool hasMovedHeadRight = false;
  bool hasMovedHeadLeft = false;
  bool hasMovedHeadUp = false;
  bool hasMovedHeadDown = false;
  bool hasMovedBlink = false;
  bool hasMovedSmile = false;
  bool hasMovedHeadCenter = false;

  LifeValidationService({
    required this.faceBloc,
    this.isRandomActionsLifeValidation = false,
    this.qteActionsLifeValidation = 4,
    this.actionsLifeValidation,
  }) {
    _initializeActions();
  }

  void _initializeActions() {
    listEnumActions = isRandomActionsLifeValidation
        ? LifeValidationTypeEnumUtils.generateRandomUnique(
            qteActionsLifeValidation,
            actionsLifeValidation ?? LifeValidationTypeEnum.values,
          )
        : LifeValidationTypeEnum.values;
  }

  void resetValidationFlags() {
    hasMovedHeadRight = false;
    hasMovedHeadLeft = false;
    hasMovedHeadUp = false;
    hasMovedHeadDown = false;
    hasMovedHeadCenter = false;
    hasMovedBlink = false;
    hasMovedSmile = false;
    passedEnumActions = [];
    _initializeActions();
  }

  void processLifeValidation(Face face, InputImage image) {
    if (passedEnumActions.length < listEnumActions.length) {
      switch (listEnumActions[passedEnumActions.length]) {
        case LifeValidationTypeEnum.right:
          _processRightMovement(face, image);
          break;
        case LifeValidationTypeEnum.left:
          _processLeftMovement(face, image);
          break;
        case LifeValidationTypeEnum.up:
          _processUpMovement(face);
          break;
        case LifeValidationTypeEnum.down:
          _processDownMovement(face);
          break;
        case LifeValidationTypeEnum.blink:
          _processBlinkMovement(face);
          break;
        case LifeValidationTypeEnum.smile:
          _processSmileMovement(face);
          break;
      }
    }

    _processCenterPosition(face);
  }

  void _processRightMovement(Face face, InputImage image) {
    if (image.metadata?.rotation == InputImageRotation.rotation90deg ||
        image.metadata?.rotation == InputImageRotation.rotation180deg) {
      if (!hasMovedHeadRight && face.headEulerAngleY! < 15) {
        faceBloc.add(MoveHeadRight());
      } else {
        hasMovedHeadRight = true;
        passedEnumActions.add(LifeValidationTypeEnum.right);
      }
    } else {
      if (!hasMovedHeadRight && face.headEulerAngleY! > -15) {
        faceBloc.add(MoveHeadRight());
      } else {
        successFeedback();
        hasMovedHeadRight = true;
        passedEnumActions.add(LifeValidationTypeEnum.right);
      }
    }
  }

  void _processLeftMovement(Face face, InputImage image) {
    if (image.metadata?.rotation == InputImageRotation.rotation90deg ||
        image.metadata?.rotation == InputImageRotation.rotation180deg) {
      if (!hasMovedHeadLeft && face.headEulerAngleY! > -15) {
        faceBloc.add(MoveHeadLeft());
      } else {
        successFeedback();
        hasMovedHeadLeft = true;
        passedEnumActions.add(LifeValidationTypeEnum.left);
      }
    } else {
      if (!hasMovedHeadLeft && face.headEulerAngleY! < 15) {
        faceBloc.add(MoveHeadLeft());
      } else {
        successFeedback();
        hasMovedHeadLeft = true;
        passedEnumActions.add(LifeValidationTypeEnum.left);
      }
    }
  }

  void _processUpMovement(Face face) {
    if (!hasMovedHeadUp && face.headEulerAngleX! < 10) {
      faceBloc.add(MoveHeadUp());
    } else {
      successFeedback();
      hasMovedHeadUp = true;
      passedEnumActions.add(LifeValidationTypeEnum.up);
    }
  }

  void _processDownMovement(Face face) {
    if (!hasMovedHeadDown && face.headEulerAngleX! > -10) {
      faceBloc.add(MoveHeadDown());
    } else {
      successFeedback();
      hasMovedHeadDown = true;
      passedEnumActions.add(LifeValidationTypeEnum.down);
    }
  }

  void _processBlinkMovement(Face face) {
    if (!hasMovedBlink &&
        (face.leftEyeOpenProbability! > 0.5 ||
            face.rightEyeOpenProbability! > 0.5)) {
      faceBloc.add(MoveBlink());
    } else {
      successFeedback();
      hasMovedBlink = true;
      passedEnumActions.add(LifeValidationTypeEnum.blink);
    }
  }

  void _processSmileMovement(Face face) {
    if (!hasMovedSmile && face.smilingProbability! < 0.5) {
      faceBloc.add(MoveSmile());
    } else {
      successFeedback();
      hasMovedSmile = true;
      passedEnumActions.add(LifeValidationTypeEnum.smile);
    }
  }

  void _processCenterPosition(Face face) {
    if (!hasMovedHeadCenter && face.headEulerAngleY! < -8 ||
        face.headEulerAngleY! > 8 ||
        face.headEulerAngleX! < -8 ||
        face.headEulerAngleX! > 8 ||
        face.leftEyeOpenProbability! < 0.5 ||
        face.rightEyeOpenProbability! < 0.5) {
      faceBloc.add(MoveHeadCenterAfter(text: "face_center_position"));
      hasMovedHeadCenter = false;
    } else {
      hasMovedHeadCenter = true;
    }
  }

  void successFeedback() {
    for (int i = 0; i < 2; i++) {
      Future.delayed(Duration(milliseconds: 200 * (i + 1)), () {
        HapticFeedback.heavyImpact();
      });
    }
  }

  bool get hasPassedHeadValidation =>
      passedEnumActions.length == listEnumActions.length && hasMovedHeadCenter;
}
