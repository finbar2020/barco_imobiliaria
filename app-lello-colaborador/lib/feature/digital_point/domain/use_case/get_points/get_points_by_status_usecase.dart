import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/repository/digital_point_repository.dart';
import 'package:essentials/essentials.dart';

class GetPointsByStatusUsecase
    extends UseCase<List<DigitalPointEntity>, GetPointsByStatusParam> {
  final DigitalPointRepository repository;

  GetPointsByStatusUsecase({required this.repository});
  @override
  Future<Try<List<DigitalPointEntity>>> call(
      GetPointsByStatusParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return await repository.getPointsByStatus(
      params.condoId,
      params.meId,
      params.pointStatus,
    );
  }

  Failure? validate(GetPointsByStatusParam? params) {
    if (params == null) return InvalidParamFailure();

    return null;
  }
}

class GetPointsByStatusParam {
  final String condoId;
  final String meId;
  final String pointStatus;

  GetPointsByStatusParam({
    required this.condoId,
    required this.meId,
    required this.pointStatus,
  });
}
