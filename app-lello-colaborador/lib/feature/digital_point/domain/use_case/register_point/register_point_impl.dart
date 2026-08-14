import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/repository/digital_point_repository.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/register_point/register_point.dart';
import 'package:essentials/essentials.dart';
import 'package:shared_features/shared_features.dart';

class RegisterPointUsecaseImpl extends RegisterPointUsecase {
  final DigitalPointRepository repository;
  final AwsUploadFileUsecase awsUploadFileUsecase;

  RegisterPointUsecaseImpl({
    required this.repository,
    required this.awsUploadFileUsecase,
  });

  @override
  Future<Try<DigitalPointEntity>> call(RegisterPointParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    Try<UrlUploadS3> uploadResponse = await awsUploadFileUsecase.call(
      AwsUploadFileParam(
        getUrlUploadS3: () async {
          return getUrlUploadS3(params.condoId);
        },
        uploadFileToS3: repository.uploadImageToAws,
        file: params.file,
      ),
    );

    UrlUploadS3? urlUploadS3 =
        uploadResponse.fold((error) => null, (res) => res);

    if (urlUploadS3 == null) {
      return Rejection<DigitalPointEntity>(
        KnownFailure("500", "upload_file_error"),
      );
    }
    params.digitalPoint.photoTempHash = urlUploadS3.fileName;
    return await registerPoint(params);
  }

  Failure? validate(RegisterPointParam? params) {
    if (params == null) return InvalidParamFailure();

    return null;
  }

  Future<Try<DigitalPointEntity>> registerPoint(
      RegisterPointParam params) async {
    return await repository.registerPoint(
        params.digitalPoint, params.condoId, params.meId);
  }

  Future<Try<UrlUploadS3>> getUrlUploadS3(String condoId) async {
    return await repository.getUrlAws(condoId);
  }
}
