import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

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
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
            aspectRatioLockEnabled: true,
            aspectRatioLockDimensionSwapEnabled: false,
            aspectRatioPresets: [CropAspectRatioPreset.square],
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
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
            aspectRatioLockEnabled: true,
            aspectRatioLockDimensionSwapEnabled: false,
            aspectRatioPresets: [CropAspectRatioPreset.square],
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
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
          aspectRatioLockEnabled: true,
          aspectRatioLockDimensionSwapEnabled: false,
          aspectRatioPresets: [CropAspectRatioPreset.square],
        )
      ],
    );
