// ignore_for_file: depend_on_referenced_packages

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lib_facedetection/lib_facedetection.dart';

class CameraViewPage extends StatefulWidget {
  final Function(dynamic file, TypeCaptureEnum captureEnum) getFile;
  final int minSecondsTakePhoto;
  final List<CameraDescription> cameras;
  final bool? hasLifeValidation;
  final bool? isRandomActionsLifeValidation;
  final int? qteActionsLifeValidation;
  final bool? isDebug;
  final TypeCaptureEnum captureEnum;
  final List<LifeValidationTypeEnum>? actionsLifeValidation;

  const CameraViewPage({
    required this.getFile,
    required this.minSecondsTakePhoto,
    this.isDebug,
    this.hasLifeValidation,
    this.isRandomActionsLifeValidation,
    this.qteActionsLifeValidation,
    this.cameras = const [],
    this.captureEnum = TypeCaptureEnum.manual,
    this.actionsLifeValidation,
    super.key,
  });

  @override
  State<CameraViewPage> createState() => _CameraViewPageState();
}

class _CameraViewPageState extends State<CameraViewPage> {
  late CameraViewController _controller;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _controller = CameraViewController(
      isDebug: widget.isDebug ?? false,
      getFile: widget.getFile,
      minSecondsToTakePhoto: widget.minSecondsTakePhoto,
      cameras: widget.cameras,
      isRandomActionsLifeValidation:
          widget.isRandomActionsLifeValidation ?? false,
      qteActionsLifeValidation: widget.qteActionsLifeValidation ?? 4,
      actionsLifeValidation: widget.actionsLifeValidation,
      typeCaptureEnum: widget.captureEnum,
      context: context,
    );

    // Select the front camera with sensor orientation 90 if available,
    // otherwise choose the first available front or external camera.
    if (widget.cameras.any((element) =>
        element.lensDirection == CameraLensDirection.front &&
        element.sensorOrientation == 90)) {
      _controller.cameraIndex = widget.cameras.indexOf(
        widget.cameras.firstWhere((element) =>
            element.lensDirection == CameraLensDirection.front &&
            element.sensorOrientation == 90),
      );
    } else {
      _controller.cameraIndex = widget.cameras.indexOf(
        widget.cameras.firstWhere((element) =>
            element.lensDirection == CameraLensDirection.front ||
            element.lensDirection == CameraLensDirection.external),
      );
    }
    _controller.startLiveFeed();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            getString(context, "face_detection_note_title"),
            textAlign: TextAlign.center,
            style: TextStyle(color: LelloTheme.palleteOf(theme).customColor()),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: LelloTheme.palleteOf(theme).customColor(),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
        ),
        body: LiveFeedBody(controller: _controller),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    WakelockPlus.disable();
    super.dispose();
  }
}
