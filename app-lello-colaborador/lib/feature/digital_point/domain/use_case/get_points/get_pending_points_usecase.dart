import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/repository/digital_point_repository.dart';
import 'package:essentials/essentials.dart';

class GetPendingPointsUsecase extends UseCase<List<DigitalPointEntity>, void> {
  final DigitalPointRepository repository;

  GetPendingPointsUsecase({required this.repository});
  @override
  Future<Try<List<DigitalPointEntity>>> call([void params]) async {
    List<DigitalPointEntity> digitalPoints = [];
    List<DigitalPointEntity> digitalPointsFilled = [];

    final result = await repository.getPendingPoints();

    result.fold(
      (failure) => throw failure,
      (points) => digitalPoints = points,
    );

    for (DigitalPointEntity point in digitalPoints) {
      final result = await repository.getPointLogs(point.id!);
      result.fold(
        (failure) => failure,
        (logs) {
          digitalPointsFilled.add(point.copyWith(logs: logs));
        },
      );
    }

    return Success(digitalPointsFilled);
  }
}
