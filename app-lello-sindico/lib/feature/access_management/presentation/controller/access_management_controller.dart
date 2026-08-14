import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:lello/feature/access_management/presentation/bloc/access_management_bloc.dart';
import 'package:lello/lello_app.dart';
import 'package:lib_facedetection/lib_facedetection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_features/shared_features.dart';

import '../../../session/presentation/bloc/session_bloc.dart';
import '../../domain/usecase/check_seventh_service/access_management_check_service.dart';
import '../../domain/usecase/facial_biometric/facial_biometric_usecase.dart';
import '../bloc/access_management_event.dart';

class AccessManagementController {
  final AccessManagementBloc accessManagementBloc;
  final AccessManagementCheckServiceCase checkServiceCase;
  final SessionBloc sessionBloc;
  final FacialBiometricUsecase facialBiometric;
  final GetImageFromCameraViewPickerUsecase getImageFromCameraViewPickerUsecase;

  AccessManagementController({
    required this.accessManagementBloc,
    required this.checkServiceCase,
    required this.sessionBloc,
    required this.facialBiometric,
    required this.getImageFromCameraViewPickerUsecase,
  });

  Future<void> checkService() async {
    final response = await checkServiceCase(
      AccessManagementCheckServiceParams(
        reference:
            sessionBloc.state.session?.selectedCondominium?.reference ?? "",
      ),
    );
    accessManagementBloc.add(AccessManagementLoadingEvent());
    response.fold(
      (error) => accessManagementBloc.add(AccessManagementErrorEvent()),
      (success) => success.condominiumActive
          ? accessManagementBloc.add(AccessManagementServiceOnEvent())
          : accessManagementBloc.add(AccessManagementServiceOffEvent()),
    );
  }

  Future<void> registerFacial() async {
    var cameras = await availableCameras();
    final image = await handleUseCase(
      getImageFromCameraViewPickerUsecase,
      ParamsGetImageFromCameraViewPickerUsecase(
        context: navigatorKey.currentState!.context,
        cameras: cameras,
        captureEnum: TypeCaptureEnum.automatic,
      ),
    );

    if (image != null && image.file != null) {
      accessManagementBloc.add(AccessManagementLoadingEvent());

      File? file = await convertFile(image.file!);

      if (file == null) {
        return accessManagementBloc.add(AccessManagementFacialFailedEvent());
      }

      final response =
          await facialBiometric.call(FacialBiometricParam(file: file));

      response.fold(
        (error) =>
            accessManagementBloc.add(AccessManagementFacialFailedEvent()),
        (result) => result.success == true
            ? accessManagementBloc.add(AccessManagementFacialSuccessEvent())
            : accessManagementBloc.add(
                AccessManagementFacialFailedEvent(
                  code: result.codigo,
                  message: result.message,
                ),
              ),
      );
    }
  }

  Future<File?> convertFile(XFile xFile) async {
    String id = DateFormat("dd_MM_yyyy_HH_mm_ss").format(DateTime.now());
    var permsStatus = await CheckPermissions.storage();
    if (permsStatus) {
      String dir = (await getApplicationDocumentsDirectory()).path;
      final Uint8List bytes = await xFile.readAsBytes();
      img.Image? image = img.decodeImage(bytes);
      if (image == null) {
        return null;
      }
      File fileConverted =
          await File("$dir/$id.jpg").writeAsBytes(img.encodeJpg(image));
      return fileConverted;
    }

    return null;
  }
}
