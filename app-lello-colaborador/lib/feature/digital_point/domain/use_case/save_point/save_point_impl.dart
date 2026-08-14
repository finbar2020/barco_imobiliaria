import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/repository/digital_point_repository.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/save_point/save_point.dart';
import 'package:essentials/essentials.dart';

class SavePointUsecaseImpl extends SavePointUsecase {
  final DigitalPointRepository repository;

  SavePointUsecaseImpl({required this.repository});
  @override
  Future<Try<DigitalPointEntity>> call(SavePointParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return await repository.savePoint(
        params.model, params.condoId, params.meId);
  }

  Failure? validate(SavePointParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condoId.isEmpty) return InvalidParamFailure();
    if (params.meId.isEmpty) return InvalidParamFailure();
    if (!params.model.isValid) return InvalidParamFailure();

    return null;
  }
}
