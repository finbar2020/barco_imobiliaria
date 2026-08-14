import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/essentials.dart' as imgLib;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' as widgets_pkg;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../bloc/camera/camera_bloc.dart';
import '../bloc/camera/camera_bloc_event.dart';
import '../bloc/camera/camera_bloc_state.dart';
import '../bloc/debug/debug_bloc.dart';
import '../bloc/facedetection/facedetection_bloc.dart';
import '../bloc/facedetection/facedetection_bloc_event.dart';
import '../bloc/facedetection/facedetection_bloc_state.dart';
import '../domain/enum/life_validation_type_enum.dart';
import '../domain/enum/type_capture_enum.dart';
import '../services/camera_timer_service.dart';
import '../services/face_detection_service.dart';
import '../services/image_processing_service.dart';
import '../services/life_validation_service.dart';

class CameraViewController {
  final FaceDetectionBloc faceBloc;
  final CameraBloc cameraBloc;
  final DebugBloc debugBloc;
  final Function(XFile? file, TypeCaptureEnum captureEnum) getFile;
  final List<CameraDescription> cameras;
  final widgets_pkg.BuildContext context;
  final bool isDebug;
  TypeCaptureEnum typeCaptureEnum;

  late CameraController cameraController;
  late FaceDetectionService faceDetectionService;
  late LifeValidationService lifeValidationService;
  late ImageProcessingService imageProcessingService;
  late CameraTimerService timerService;

  CameraImage? _latestCameraImage;
  int cameraIndex = 0;
  bool canProcess = true;
  bool isBusy = false;
  bool automatiProcessDisabled = false;
  bool atleatOneFace = false;
  bool okToPhoto = false;

  CameraViewController({
    required this.getFile,
    required this.cameras,
    required this.context,
    this.isDebug = false,
    bool isRandomActionsLifeValidation = false,
    int qteActionsLifeValidation = 4,
    int minSecondsToTakePhoto = 3,
    this.typeCaptureEnum = TypeCaptureEnum.manual,
    List<LifeValidationTypeEnum>? actionsLifeValidation,
  })  : faceBloc = FaceDetectionBloc(FaceMovingState()),
        cameraBloc = CameraBloc(LoadingCameraState()),
        debugBloc = DebugBloc(LoadingDebugState()) {
    faceDetectionService = FaceDetectionService(faceBloc: faceBloc);
    lifeValidationService = LifeValidationService(
      faceBloc: faceBloc,
      isRandomActionsLifeValidation: isRandomActionsLifeValidation,
      qteActionsLifeValidation: qteActionsLifeValidation,
      actionsLifeValidation: actionsLifeValidation,
    );
    imageProcessingService = ImageProcessingService();
    timerService =
        CameraTimerService(minSecondsToTakePhoto: minSecondsToTakePhoto);
  }

  Future<void> startLiveFeed() async {
    timerService.startTimers();
    Timer(const Duration(seconds: 15), checkProcessOk);

    final camera = cameras[cameraIndex];
    cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await cameraController.initialize();

    if (!kIsWeb) {
      await cameraController.setFlashMode(FlashMode.off);
    }

    cameraBloc.add(SuccessCamera());

    if (typeCaptureEnum.isManual) {
      cameraBloc.add(ManualCapture());
      faceBloc.add(TakeManualPhoto());
    }

    await _startImageStream();
  }

  Future<void> _startImageStream() async {
    await cameraController
        .startImageStream(
          (image) async {
            if (isManualCapture) {
              _latestCameraImage = null; // No modo manual, não salvamos imagem
              cameraBloc.add(ManualCapture());
              faceBloc.add(TakeManualPhoto());
              cameraController
                  .stopImageStream()
                  .onError((error, stackTrace) => null);
              return;
            }
            final inputImage = _inputImageFromCameraImage(image);
            if (inputImage != null) {
              processImage(inputImage, image);
            }
          },
        )
        .timeout(const Duration(seconds: 1))
        .onError(
            (error, stackTrace) => typeCaptureEnum = TypeCaptureEnum.manual);
  }

  Future<void> processImage(InputImage inputImage, CameraImage image) async {
    if (!canProcess || isBusy) return;
    isBusy = true;

    final faces = await faceDetectionService.detectFaces(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      await _handleFaceDetection(faces, inputImage, image);
    }

    isBusy = false;
    timerService.incrementFaceCheck();
  }

  Future<void> _handleFaceDetection(
    List<Face> faces,
    InputImage inputImage,
    CameraImage image,
  ) async {
    final Face? oneFace = faces.length == 1 ? faces.first : null;

    if (isManualCapture) {
      if (cameraBloc.state is! ManualCaptureState) {
        _latestCameraImage = image; // No modo manual, salvamos a imagem
        cameraBloc.add(ManualCapture());
        faceBloc.add(TakeManualPhoto());
      }
      return;
    }

    timerService.handleFaceDetected(
      isDetected: oneFace != null,
      onNoFaceDetected: () {
        lifeValidationService.resetValidationFlags();
        timerService.restartTakePhotoCounter();
        faceBloc.add(DetectionFailure());
        // Reset to default tolerance when no face is detected
        faceDetectionService.setDefaultTolerance();
      },
    );

    if (oneFace != null) {
      atleatOneFace = true;
      debugBloc.add(
        SendDebugEvent(
          face: oneFace,
          rotation: inputImage.metadata!.rotation.rawValue,
          performace: timerService.performanceMetric,
        ),
      );

      // Set increased tolerance during liveness validation
      if (typeCaptureEnum.isLifeValidation &&
          !timerService.disableLifeValidation) {
        faceDetectionService.setLivenessTolerance();
      }

      String instructions = faceDetectionService.getCentralizationInstructions(
          oneFace, inputImage);
      faceBloc.add(MoveHeadCenterAfter(text: instructions));
      okToPhoto = instructions.isEmpty;

      if (okToPhoto) {
        _latestCameraImage = image; // Salvamos a imagem apenas quando aprovada
        await _handlePhotoCapture(oneFace, inputImage);
      } else {
        timerService.restartTakePhotoCounter();
      }
    }
  }

  Future<void> _handlePhotoCapture(Face face, InputImage inputImage) async {
    if (typeCaptureEnum.isLifeValidation &&
        !timerService.disableLifeValidation) {
      timerService.startLifeValidationTimer();

      lifeValidationService.processLifeValidation(face, inputImage);
      if (lifeValidationService.hasPassedHeadValidation) {
        timerService.setLifeValidationComplete();
      }
    }

    if (!typeCaptureEnum.isLifeValidation ||
        lifeValidationService.hasPassedHeadValidation ||
        timerService.disableLifeValidation) {
      if (!timerService.hasStartedCounting) {
        timerService.setLifeValidationComplete();
      }
      timerService.incrementTakePhoto();
      faceBloc.add(FaceDetected(count: timerService.countDownTakePhoto));
      if (timerService.isSuficientTimeToCapture) {
        await takePicture();
      }
    }
  }

  Future<void> takePicture() async {
    TypeCaptureEnum captureEnum = typeCaptureEnum;
    canProcess = false;

    if (isManualCapture) {
      captureEnum = TypeCaptureEnum.manual;
    }
    if (timerService.disableLifeValidation) {
      captureEnum = TypeCaptureEnum.automatic;
    }

    try {
      XFile originalFile =
          kIsWeb ? await takePictureWeb() : await takePictureMobile();

      final processedFile =
          await imageProcessingService.processImage(originalFile);

      getFile(processedFile, captureEnum);
    } catch (e) {
      getFile(null, captureEnum);
    }
  }

  Future<XFile> takePictureMobile() async {
    Stopwatch start = Stopwatch()..start();
    await cameraController
        .stopImageStream()
        .onError((error, stackTrace) => null);
    faceDetectionService.dispose();

    XFile picture;

    if (_latestCameraImage != null) {
      // Convert and use the latest camera image
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/latest_capture.jpg';

      Uint8List? processedBytes;
      if (Platform.isAndroid) {
        processedBytes = _convertYUV420ToNV21(_latestCameraImage!);
      } else if (Platform.isIOS) {
        processedBytes = _latestCameraImage!.planes[0].bytes;
      }

      if (processedBytes != null) {
        final imgLib.Image? img = await compute(decodeImage, processedBytes);
        if (img != null) {
          final jpg = imgLib.encodeJpg(img);
          await File(tempPath).writeAsBytes(jpg);
          picture = XFile(tempPath);
        } else {
          picture = await cameraController.takePicture();
        }
      } else {
        picture = await cameraController.takePicture();
      }
    } else {
      picture = await cameraController.takePicture();
    }

    if (!isManualCapture) {
      cameraController.setFocusMode(FocusMode.auto);
      cameraController.setExposureMode(ExposureMode.auto);
    }

    FirebaseAnalytics.instance.logEvent(
      name: "biometric_photo",
      parameters: {
        "elapsed_seconds": "${start.elapsed.inSeconds}",
        "elapsed_total_seconds":
            "${timerService.totalCapture.elapsed.inSeconds}",
        "automatic": "$isManualCapture",
        "ticks_total": "${timerService.ticksFaceCheck}",
        "ticks_performace": "${timerService.performanceMetric}",
      },
    );

    return picture;
  }

  Future<XFile> takePictureWeb() async {
    faceDetectionService.dispose();
    return await cameraController.takePicture();
  }

  void checkProcessOk() {
    if (!isManualCapture && timerService.ticksFaceCheck < 3) {
      typeCaptureEnum = TypeCaptureEnum.manual;
      cameraBloc.add(ManualCapture());
      faceBloc.add(TakeManualPhoto());
      FirebaseCrashlytics.instance
          .recordError(Exception("BiometricProcessNOK"), StackTrace.current);
    }
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    final camera = cameras[cameraIndex];
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;

    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[cameraController.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

    // Handle platform-specific image format
    final bytes =
        Platform.isIOS ? image.planes[0].bytes : _convertYUV420ToNV21(image);
    final imageFormat =
        Platform.isIOS ? InputImageFormat.bgra8888 : InputImageFormat.nv21;

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: widgets_pkg.Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: imageFormat,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }

  Uint8List _convertYUV420ToNV21(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final int ySize = width * height;
    final int uvSize = width * height ~/ 4;
    Uint8List nv21 = Uint8List(ySize + (uvSize * 2));
    int yIndex = 0;
    int uvIndex = ySize;

    for (int i = 0; i < ySize; i++) {
      nv21[yIndex++] = image.planes[0].bytes[i];
    }

    for (int i = 0; i < uvSize; i++) {
      nv21[uvIndex++] = image.planes[1].bytes[i];
      nv21[uvIndex++] = image.planes[2].bytes[i];
    }

    return nv21;
  }

  final Map<DeviceOrientation, int> _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  bool get isManualCapture =>
      typeCaptureEnum.isManual ||
      kIsWeb ||
      automatiProcessDisabled ||
      (timerService.isTimeoutReached && atleatOneFace == false);

  void dispose() {
    canProcess = false;
    _latestCameraImage = null;
    // Dispose camera
    cameraController.dispose();

    // Dispose services
    faceDetectionService.dispose();

    // Close blocs
    faceBloc.close();
    cameraBloc.close();
    debugBloc.close();
  }
}
