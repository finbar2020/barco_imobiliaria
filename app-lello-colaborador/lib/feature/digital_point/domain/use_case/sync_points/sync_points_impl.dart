import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/repository/digital_point_repository.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/sync_points/sync_points.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/upload_digital_point_to_aws/upload_digital_point_to_aws.dart';
import 'package:essentials/essentials.dart';

class SyncPointsUsecaseImpl extends SyncPointsUsecase {
  final DigitalPointRepository repository;
  final UploadDigitalPointToAwsUsecase uploadDigitalPointToAwsUsecase;

  SyncPointsUsecaseImpl({
    required this.repository,
    required this.uploadDigitalPointToAwsUsecase,
  });
  @override
  Future<Try<List<DigitalPointEntity>>> call(SyncPointsParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    String condoId = params.condoId;
    String meId = params.meId;

    List<Future<Try<DigitalPointEntity>>> pointsToAws = List.generate(
      params.digitalPoints.length,
      (index) => uploadDigitalPointToAwsUsecase.call(
        UploadDigitalPointToAwsParam(
          getUrlUploadS3: repository.getUrlAws,
          uploadFileToS3: repository.uploadImageToAws,
          digitalPointEntity: params.digitalPoints[index],
          condoId: condoId,
        ),
      ),
    );

    List<DigitalPointEntity> pointsToSync = [];
    await Future.wait(pointsToAws).then(
      (value) {
        for (Try<DigitalPointEntity> element in value) {
          element.fold((error) => null, (res) => pointsToSync.add(res));
        }
      },
    );

    return await repository.syncPoints(condoId, meId, pointsToSync);
  }

  Failure? validate(SyncPointsParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condoId.isEmpty) return InvalidParamFailure();
    if (params.meId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
