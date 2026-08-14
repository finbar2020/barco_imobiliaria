import 'package:colaborador/feature/employee_referral/domain/entity/employee_referral.dart';
import 'package:colaborador/feature/employee_referral/domain/repository/employee_referral_repository.dart';
import 'package:colaborador/feature/employee_referral/domain/use_case/register_employee_referral/employee_referral.dart';
import 'package:essentials/essentials.dart';
import 'package:shared_features/shared_features.dart';

class RegisterEmployeeReferralUsecaseImpl
    extends RegisterEmployeeReferralUsecase {
  final EmployeeReferralRepository repository;
  final AwsUploadFileUsecase awsUploadFileUsecase;

  RegisterEmployeeReferralUsecaseImpl({
    required this.repository,
    required this.awsUploadFileUsecase,
  });

  @override
  Future<Try<EmployeeReferralEntity>> call(
      RegisterEmployeeReferralParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    Try<UrlUploadS3> uploadResponse = await awsUploadFileUsecase.call(
      AwsUploadFileParam(
        getUrlUploadS3: () async {
          return getUrlUploadS3(params.condoId, params.employeeId);
        },
        uploadFileToS3: repository.uploadImageToAws,
        file: params.employeeReferralEntity.file!,
      ),
    );

    UrlUploadS3? urlUploadS3 =
        uploadResponse.fold((error) => null, (res) => res);

    if (urlUploadS3 == null) {
      return Rejection<EmployeeReferralEntity>(
        KnownFailure("500", "upload_file_error"),
      );
    }
    params.employeeReferralEntity.fileTempHash = urlUploadS3.fileName;
    return await registerEmployeeReferral(params);
  }

  Failure? validate(RegisterEmployeeReferralParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.employeeReferralEntity.file == null) {
      return InvalidParamFailure();
    }
    if (params.employeeReferralEntity.city == null) {
      return InvalidParamFailure();
    }
    if (params.employeeReferralEntity.description == null) {
      return InvalidParamFailure();
    }

    return null;
  }

  Future<Try<EmployeeReferralEntity>> registerEmployeeReferral(
      RegisterEmployeeReferralParam params) async {
    return await repository.registerEmployeeReferral(
        params.employeeReferralEntity, params.condoId, params.employeeId);
  }

  Future<Try<UrlUploadS3>> getUrlUploadS3(
      String condoId, String employeeId) async {
    return await repository.getUrlAws(condoId, employeeId);
  }
}
