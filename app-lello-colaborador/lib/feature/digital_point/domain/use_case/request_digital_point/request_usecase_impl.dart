import 'package:colaborador/feature/digital_point/domain/repository/digital_point_repository.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/request_digital_point/request_usecase.dart';
import 'package:essentials/essentials.dart';
import 'package:shared_features/shared_features.dart';

class RequestDigitalUsecaseImpl extends RequestDigitalUsecase {
  final DigitalPointRepository repository;
  final AwsUploadFileUsecase awsUploadFileUsecase;

  RequestDigitalUsecaseImpl({
    required this.repository,
    required this.awsUploadFileUsecase,
  });

  @override
  Future<Try<bool>> call(RequestDigitalParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    Try<UrlUploadS3> uploadResponse = await awsUploadFileUsecase.call(
      AwsUploadFileParam(
        getUrlUploadS3: () async {
          return await repository.getUrlAws(params.condoId);
        },
        uploadFileToS3: repository.uploadImageToAws,
        file: params.file,
      ),
    );

    UrlUploadS3? urlUploadS3 =
        uploadResponse.fold((error) => null, (res) => res);

    if (urlUploadS3 == null) {
      return Rejection<bool>(
        KnownFailure("500", "upload_file_error"),
      );
    }

    return await requestDigital(params, urlUploadS3);
  }

  Failure? validate(RequestDigitalParam? params) {
    if (params == null) return InvalidParamFailure();

    return null;
  }

  Future<Try<bool>> requestDigital(
      RequestDigitalParam params, UrlUploadS3 urlUploadS3) async {
    return await repository.requestDigitalPoint(
        params.condoId, urlUploadS3.fileName);
  }
}
