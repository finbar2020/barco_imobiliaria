import 'package:colaborador/feature/digital_point/domain/entity/digital_point_register_failure.dart';
import 'package:colaborador/feature/digital_point/domain/repository/digital_point_repository.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/sync_point_without_login/sync_point_without_login.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/upload_digital_point_to_aws/upload_digital_point_to_aws.dart';
import 'package:essentials/essentials.dart';

class SyncPointWithoutLoginUsecaseImpl extends SyncPointWithoutLoginUsecase {
  final DigitalPointRepository repository;
  final UploadDigitalPointToAwsUsecase uploadDigitalPointToAwsUsecase;

  SyncPointWithoutLoginUsecaseImpl({
    required this.repository,
    required this.uploadDigitalPointToAwsUsecase,
  });
  @override
  Future<Try<void>> call(SyncPointWithoutLoginParam params) async {
    final error = validate(params);
    if (error != null) {
      await repository.savePointLog(
          params.digitalPoint,
          enumToString(params.digitalPoint.status) ?? "pending",
          DigitalPointRegisterFailure.invalidParametersForOffline);
      return Rejection(error);
    }

    final uploadResult = await uploadDigitalPointToAwsUsecase(
      UploadDigitalPointToAwsParam(
        getUrlUploadS3: repository.getUrlAws,
        uploadFileToS3: repository.uploadImageToAws,
        digitalPointEntity: params.digitalPoint,
        condoId: params.digitalPoint.reference ?? "",
      ),
    );

    final Try<void> syncResult = await uploadResult.fold(
      (failure) async {
        await repository.savePointLog(
            params.digitalPoint,
            enumToString(params.digitalPoint.status) ?? "pending",
            DigitalPointRegisterFailure.photoUploadFail);
        return Try.reject(failure);
      },
      (point) {
        return repository.syncPointWithoutLogin(point: point);
      },
    );
    return syncResult;
  }

  Failure? validate(SyncPointWithoutLoginParam? params) {
    if (params == null) return InvalidParamFailure();
    if (!params.digitalPoint.isValid) return InvalidParamFailure();
    if (params.digitalPoint.reference == null ||
        params.digitalPoint.reference?.isEmpty == true) {
      return InvalidParamFailure();
    }
    if (params.digitalPoint.numCad == null ||
        params.digitalPoint.numCad?.isEmpty == true) {
      return InvalidParamFailure();
    }
    if (params.digitalPoint.numCra == null ||
        params.digitalPoint.numCra?.isEmpty == true) {
      return InvalidParamFailure();
    }
    return null;
  }
}
