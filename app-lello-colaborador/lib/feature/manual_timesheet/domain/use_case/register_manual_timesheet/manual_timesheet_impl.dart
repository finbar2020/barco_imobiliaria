
import 'package:colaborador/feature/manual_timesheet/domain/entity/manual_timesheet.dart';
import 'package:colaborador/feature/manual_timesheet/domain/repository/manual_timesheet_repository.dart';
import 'package:colaborador/feature/manual_timesheet/domain/use_case/register_manual_timesheet/manual_timesheet.dart';
import 'package:essentials/essentials.dart';
import 'package:shared_features/shared_features.dart';

class RegisterManualTimeSheetUsecaseImpl extends RegisterManualTimeSheetUsecase {
  final ManualTimeSheetRepository repository;
  final AwsUploadFileUsecase awsUploadFileUsecase;

  RegisterManualTimeSheetUsecaseImpl({
    required this.repository,
    required this.awsUploadFileUsecase,
  });

  @override
  Future<Try<ManualTimeSheetEntity>> call(RegisterManualTimeSheetParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    Try<UrlUploadS3> uploadResponse = await awsUploadFileUsecase.call(
      AwsUploadFileParam(
        getUrlUploadS3: () async {
          return getUrlUploadS3(params.condoId);
        },
        uploadFileToS3: repository.uploadImageToAws,
        file: params.manualTimeSheetEntity.file!,
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
    return await registerManualTimeSheet(params);
  }

  Failure? validate(RegisterManualTimeSheetParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.manualTimeSheetEntity.file == null) return InvalidParamFailure();
    if (params.manualTimeSheetEntity.date == null) return InvalidParamFailure();

    return null;
  }

  Future<Try<ManualTimeSheetEntity>> registerManualTimeSheet(
      RegisterManualTimeSheetParam params) async {
    return await repository.registerManualTimeSheet(
        params.manualTimeSheetEntity, params.condoId, params.meId);
  }

  Future<Try<UrlUploadS3>> getUrlUploadS3(String condoId) async {
    return await repository.getUrlAws(condoId);
  }
}
