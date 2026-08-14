import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/repository/digital_point_repository.dart';
import 'package:essentials/essentials.dart';

class GetPointsUsecase
    extends UseCase<List<DigitalPointEntity>, GetPointsParam> {
  final DigitalPointRepository repository;

  GetPointsUsecase({required this.repository});
  @override
  Future<Try<List<DigitalPointEntity>>> call(GetPointsParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);
    List<DigitalPointEntity> digitalPoints = [];
    List<DigitalPointEntity> digitalPointsFilled = [];

    final result = await repository.getPoints(
      params.condoId,
      params.meId,
    );

    result.fold(
      (failure) => throw failure,
      (points) => digitalPoints = points,
    );

    for (DigitalPointEntity point in digitalPoints) {
      final result = await repository.getPointLogs(point.id!);
      result.fold(
        (failure) => failure,
        (logs) {
          digitalPointsFilled.add(
            point.copyWith(
              logs: logs,
            ),
          );
        },
      );
    }

    return Success(digitalPointsFilled);
  }

  Failure? validate(GetPointsParam? params) {
    if (params == null) return InvalidParamFailure();

    return null;
  }
}

class GetPointsParam {
  final String condoId;
  final String meId;

  GetPointsParam({
    required this.condoId,
    required this.meId,
  });
}
