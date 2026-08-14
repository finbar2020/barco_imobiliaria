import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../colors/light_pallete.dart';

Future<CroppedFile?> showGeneralImageCropper(
  String path, {
  BuildContext? context,
  int? maxHeight,
  int? maxWidth,
  List<CropAspectRatioPreset> aspectRatioPresets = const [
    CropAspectRatioPreset.square
  ],
  CropStyle cropStyle = CropStyle.rectangle,
}) async {
  Color toolbarColor = LightPallete().primary();

  if (context != null) {
    toolbarColor = Theme.of(context).primaryColor;
  }

  return await ImageCropper().cropImage(
      sourcePath: path,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      uiSettings: [
        AndroidUiSettings(
            toolbarColor: toolbarColor,
            toolbarWidgetColor: Colors.white,
            hideBottomControls: true,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
              ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
          aspectRatioLockEnabled: true,
          aspectRatioLockDimensionSwapEnabled: false,
          aspectRatioPresets: [CropAspectRatioPreset.original],
        )
      ]);
}

Future<CroppedFile?> showImageCropper(String path,
        {int? maxHeight, int? maxWidth}) async =>
    await ImageCropper().cropImage(
        sourcePath: path,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
        uiSettings: [
          AndroidUiSettings(
              toolbarColor: LightPallete().primary(),
              toolbarWidgetColor: Colors.white,
              hideBottomControls: true,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
            aspectRatioLockEnabled: true,
            aspectRatioLockDimensionSwapEnabled: false,
            aspectRatioPresets: [CropAspectRatioPreset.original],
          )
        ]);

Future<CroppedFile?> showReceiptCropper(String path,
        {int? maxHeight, int? maxWidth}) async =>
    await ImageCropper().cropImage(
        sourcePath: path,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
        uiSettings: [
          AndroidUiSettings(
              toolbarColor: LightPallete().primary(),
              toolbarWidgetColor: Colors.white,
              hideBottomControls: true,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
            aspectRatioLockEnabled: true,
            aspectRatioLockDimensionSwapEnabled: false,
            aspectRatioPresets: [CropAspectRatioPreset.original],
          )
        ]);

Future<CroppedFile?> showProfileImageCropper(String path,
        {int? maxHeight, int? maxWidth}) async =>
    await ImageCropper().cropImage(
      sourcePath: path,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      uiSettings: [
        AndroidUiSettings(
            toolbarColor: LightPallete().primary(),
            toolbarWidgetColor: Colors.white,
            hideBottomControls: true,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
          aspectRatioLockEnabled: true,
          aspectRatioLockDimensionSwapEnabled: false,
          aspectRatioPresets: [CropAspectRatioPreset.original],
        )
      ],
    );
