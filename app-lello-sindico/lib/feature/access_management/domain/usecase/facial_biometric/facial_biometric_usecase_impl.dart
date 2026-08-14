import 'package:essentials/essentials.dart';
import 'package:lello/feature/access_management/domain/entity/access_control_register_facial_response.dart';
import 'package:lello/feature/access_management/domain/repository/access_management_repository.dart';
import 'package:lello/feature/access_management/domain/usecase/facial_biometric/facial_biometric_usecase.dart';
import 'package:shared_features/shared_features.dart';

class FacialBiometricUsecaseImpl extends FacialBiometricUsecase {
  final AccessManagementRepository repository;
  final AwsUploadFileUsecase awsUploadFileUsecase;

  FacialBiometricUsecaseImpl({
    required this.repository,
    required this.awsUploadFileUsecase,
  });

  @override
  Future<Try<AccessControlRegisterFacialResponse>> call(
      FacialBiometricParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    Try<UrlUploadS3> uploadResponse = await awsUploadFileUsecase.call(
      AwsUploadFileParam(
        getUrlUploadS3: () async {
          return getUrlUploadS3();
        },
        uploadFileToS3: repository.uploadImageToAws,
        file: params.file,
      ),
    );

    UrlUploadS3? urlUploadS3 =
        uploadResponse.fold((error) => null, (res) => res);

    if (urlUploadS3 == null) {
      return Rejection<AccessControlRegisterFacialResponse>(
        KnownFailure("500", "upload_file_error"),
      );
    }
    return await registerFacialBiometric(urlUploadS3.fileName);
  }

  Failure? validate(FacialBiometricParam params) {
    if (params.file.path.isEmpty) return InvalidParamFailure();

    return null;
  }

  Future<Try<UrlUploadS3>> getUrlUploadS3() async {
    return await repository.getUrlAws();
  }

  Future<Try<AccessControlRegisterFacialResponse>> registerFacialBiometric(
      String hash) async {
    return await repository.registerFacialBiometric(hash);
  }
}
