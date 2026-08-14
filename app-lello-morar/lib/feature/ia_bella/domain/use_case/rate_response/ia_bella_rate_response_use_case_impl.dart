import 'package:essentials/essentials.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_rate_response_entity.dart';
import 'package:morar/feature/ia_bella/domain/repository/ia_bella_repository.dart';
import 'package:morar/feature/ia_bella/domain/use_case/rate_response/ia_bella_rate_response_use_case.dart';

class IaBellaRateResponseUseCaseImpl extends IaBellaRateResponseUseCase {
  final IaBellaRepository repository;

  IaBellaRateResponseUseCaseImpl({required this.repository});

  @override
  Future<Try<IaBellaRateResponseEntity>> call(
      IaBellaRateResponseParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.evaluate(params.condominiumId, params.userRate);
  }

  Failure? _validate(IaBellaRateResponseParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    if (param.userRate.responseId == null) return InvalidParamFailure();
    return null;
  }
}
