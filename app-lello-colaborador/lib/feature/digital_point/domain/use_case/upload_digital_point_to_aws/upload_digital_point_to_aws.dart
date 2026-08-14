import 'dart:io';

import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:essentials/essentials.dart';
import 'package:shared_features/shared_features.dart';

abstract class UploadDigitalPointToAwsUsecase
    extends UseCase<DigitalPointEntity, UploadDigitalPointToAwsParam> {}

class UploadDigitalPointToAwsParam {
  final Future<Try<UrlUploadS3>> Function(String condoId) getUrlUploadS3;
  final Future<Try<String>> Function(File file, String url) uploadFileToS3;
  final DigitalPointEntity digitalPointEntity;
  final String condoId;

  UploadDigitalPointToAwsParam({
    required this.getUrlUploadS3,
    required this.uploadFileToS3,
    required this.digitalPointEntity,
    required this.condoId,
  });
}
