import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/repository/digital_point_repository.dart';
import 'package:essentials/essentials.dart';

class GetPointsNoAuthUsecase
    extends UseCase<List<DigitalPointEntity>, GetPointsNoAuthParam> {
  final DigitalPointRepository repository;

  GetPointsNoAuthUsecase({required this.repository});
  @override
  Future<Try<List<DigitalPointEntity>>> call(
      GetPointsNoAuthParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    Try<List<DigitalPointEntity>> response =
        await repository.getPendingPoints();
    return response;
  }

  Failure? validate(GetPointsNoAuthParam? params) {
    if (params == null) return InvalidParamFailure();

    return null;
  }
}

class GetPointsNoAuthParam {
  GetPointsNoAuthParam();
}
