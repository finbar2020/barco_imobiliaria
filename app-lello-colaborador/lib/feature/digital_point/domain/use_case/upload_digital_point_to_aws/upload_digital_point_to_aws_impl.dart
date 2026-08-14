import 'dart:io';

import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/repository/digital_point_repository.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/upload_digital_point_to_aws/upload_digital_point_to_aws.dart';
import 'package:essentials/essentials.dart';
import 'package:shared_features/shared_features.dart';

class UploadDigitalPointToAwsUsecaseImpl
    extends UploadDigitalPointToAwsUsecase {
  final DigitalPointRepository repository;
  final AwsUploadFileUsecase awsUploadFileUsecase;

  UploadDigitalPointToAwsUsecaseImpl({
    required this.repository,
    required this.awsUploadFileUsecase,
  });

  @override
  Future<Try<DigitalPointEntity>> call(
      UploadDigitalPointToAwsParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    Try<UrlUploadS3> uploadResponse = await awsUploadFileUsecase.call(
      AwsUploadFileParam(
        getUrlUploadS3: () async {
          return await repository.getUrlAws(params.condoId);
        },
        uploadFileToS3: repository.uploadImageToAws,
        file: File(params.digitalPointEntity.photoPath),
      ),
    );

    UrlUploadS3? urlUploadS3 =
        uploadResponse.fold((error) => null, (res) => res);

    if (urlUploadS3 == null) {
      return Rejection<DigitalPointEntity>(
        KnownFailure("500", "upload_file_error"),
      );
    }

    params.digitalPointEntity.photoTempHash = urlUploadS3.fileName;
    return Success(params.digitalPointEntity);
  }

  Failure? validate(UploadDigitalPointToAwsParam? params) {
    if (params == null) return InvalidParamFailure();

    return null;
  }
}
