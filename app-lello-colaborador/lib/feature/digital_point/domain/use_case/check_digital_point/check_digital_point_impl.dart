import 'package:colaborador/feature/digital_point/domain/repository/digital_point_repository.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/check_digital_point/check_digital_point.dart';
import 'package:essentials/essentials.dart';

class CheckDigitalPointUsecaseImpl extends CheckDigitalPointUsecase {
  final DigitalPointRepository repository;

  CheckDigitalPointUsecaseImpl({required this.repository});
  @override
  Future<Try<bool>> call(CheckDigitalPointParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return await repository.checkDigitalPoint(params.condoId, params.date);
  }

  Failure? validate(CheckDigitalPointParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condoId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
