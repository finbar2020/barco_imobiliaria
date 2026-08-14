import 'dart:io';

import 'package:colaborador/feature/manual_timesheet/domain/entity/manual_timesheet.dart';
import 'package:colaborador/feature/manual_timesheet/domain/repository/manual_timesheet_repository.dart';
import 'package:colaborador/feature/manual_timesheet/domain/use_case/upload_sick_note_to_aws/upload_manual_timesheet_to_aws.dart';
import 'package:essentials/essentials.dart';
import 'package:shared_features/shared_features.dart';

class UploadManualTimeSheetToAwsUsecaseImpl extends UploadManualTimeSheetToAwsUsecase {
  final ManualTimeSheetRepository repository;
  final AwsUploadFileUsecase awsUploadFileUsecase;

  UploadManualTimeSheetToAwsUsecaseImpl({
    required this.repository,
    required this.awsUploadFileUsecase,
  });

  @override
  Future<Try<ManualTimeSheetEntity>> call(UploadManualTimeSheetToAwsParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    Try<UrlUploadS3> uploadResponse = await awsUploadFileUsecase.call(
      AwsUploadFileParam(
        getUrlUploadS3: () async {
          return await repository.getUrlAws(params.condoId);
        },
        uploadFileToS3: repository.uploadImageToAws,
        file: File(params.manualTimeSheetEntity.filePath!),
      ),
    );

    UrlUploadS3? urlUploadS3 =
        uploadResponse.fold((error) => null, (res) => res);

    if (urlUploadS3 == null) {
      return Rejection<ManualTimeSheetEntity>(
        KnownFailure("500", "upload_file_error"),
      );
    }

    params.manualTimeSheetEntity.fileTempHash = urlUploadS3.fileName;
    return Success(params.manualTimeSheetEntity);
  }

  Failure? validate(UploadManualTimeSheetToAwsParam? params) {
    if (params == null) return InvalidParamFailure();
    return null;
  }
}
