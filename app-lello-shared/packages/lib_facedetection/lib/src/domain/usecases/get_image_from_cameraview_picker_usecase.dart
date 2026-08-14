// ignore_for_file: use_build_context_synchronously

import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:lib_facedetection/src/error/failures.dart';
import 'package:shared_features/feature/access_settings_permission_denied/entity/access_settings_permissions_denied_item.dart';
import 'package:shared_features/feature/access_settings_permission_denied/presentation/page/access_settings_permission_denied_page.dart';
import 'package:shared_features/shared_features.dart';

import '../../../lib_facedetection.dart';

class GetImageFromCameraViewPickerUsecase
    implements
        UseCase<CameraViewPickerResult?,
            ParamsGetImageFromCameraViewPickerUsecase> {
  @override
  Future<Either<IFailure, CameraViewPickerResult?>> call(params) async {
    CameraViewPickerResult? result;
    bool permission = await CheckPermissions.camera();
    if (!permission) {
      await Navigator.of(params.context).pushNamed(
        SharedApplicationRoute.accessSettingsPermissionDenied,
        arguments: AcessSettingsPermissionDeniedPageArgs(
          acessSettingsPermissionsDeniedItem:
              AcessSettingsPermissionsDeniedItem(
            item: AcessSettingsPermissionsDeniedItemEnum.cam,
            isColaboradorApp: params.isColaboradorApp,
          ),
        ),
      );
      return const Left(
        PermissionFailure(),
      );
    }

    await FaceDetectionDialog.show(
      params.context,
      () => Navigator.pop(params.context),
    );

    await Navigator.push(
      params.context,
      MaterialPageRoute(
        builder: (context) => CameraViewPage(
          cameras: params.cameras,
          isRandomActionsLifeValidation: params.isRandomActionsLifeValidation,
          qteActionsLifeValidation: params.qteActionsLifeValidation,
          actionsLifeValidation: params.actionsLifeValidation,
          isDebug: params.isDebug,
          captureEnum: params.captureEnum,
          getFile: (xfile, captureEnum) {
            result = CameraViewPickerResult(
              captureEnum: captureEnum,
              file: xfile,
            );
            Navigator.pop(context);
          },
          minSecondsTakePhoto: 3,
        ),
      ),
    );

    return Right(result);
  }
}

class ParamsGetImageFromCameraViewPickerUsecase extends IParams {
  final BuildContext context;
  final bool isColaboradorApp;
  List<CameraDescription> cameras;
  bool isRandomActionsLifeValidation;
  int qteActionsLifeValidation;
  bool isDebug;
  TypeCaptureEnum captureEnum;
  List<LifeValidationTypeEnum>? actionsLifeValidation;
  ParamsGetImageFromCameraViewPickerUsecase({
    required this.context,
    required this.cameras,
    required this.captureEnum,
    this.isColaboradorApp = false,
    this.isDebug = false,
    this.isRandomActionsLifeValidation = false,
    this.qteActionsLifeValidation = 4,
    this.actionsLifeValidation,
  });
}
