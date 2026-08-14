import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lib_facedetection/lib_facedetection.dart';

class ManualCaptureButton extends StatelessWidget {
  final CameraViewController controller;
  final Function(XFile file, TypeCaptureEnum captureEnum) getFile;
  const ManualCaptureButton({
    super.key,
    required this.controller,
    required this.getFile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimens.spacingMedium),
      height: Dimens.spacingXLarge,
      width: Dimens.spacingXLarge,
      child: FittedBox(
        child: FloatingActionButton(
          // Provide an onPressed callback.
          onPressed: () async {
            controller.takePicture();
          },
          child: const Icon(Icons.camera_alt),
        ),
      ),
    );
  }
}
