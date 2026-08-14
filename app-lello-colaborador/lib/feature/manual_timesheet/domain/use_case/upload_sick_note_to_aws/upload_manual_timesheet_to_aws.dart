import 'dart:io';

import 'package:colaborador/feature/manual_timesheet/domain/entity/manual_timesheet.dart';
import 'package:essentials/essentials.dart';
import 'package:shared_features/shared_features.dart';

abstract class UploadManualTimeSheetToAwsUsecase
    extends UseCase<ManualTimeSheetEntity, UploadManualTimeSheetToAwsParam> {}

class UploadManualTimeSheetToAwsParam {
  final Future<Try<UrlUploadS3>> Function(String condoId) getUrlUploadS3;
  final Future<Try<String>> Function(File file, String url) uploadFileToS3;
  final ManualTimeSheetEntity manualTimeSheetEntity;
  final String condoId;

  UploadManualTimeSheetToAwsParam({
    required this.getUrlUploadS3,
    required this.uploadFileToS3,
    required this.manualTimeSheetEntity,
    required this.condoId,
  });
}
