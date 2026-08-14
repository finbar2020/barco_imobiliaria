import 'package:essentials/essentials.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_data_entity.dart';
import 'package:morar/feature/ia_bella/domain/repository/ia_bella_repository.dart';
import 'package:morar/feature/ia_bella/domain/use_case/start_session/ia_bella_start_session_use_case.dart';

class IaBellaStartSessionUseCaseImpl extends IaBellaStartSessionUseCase {
  final IaBellaRepository repository;

  IaBellaStartSessionUseCaseImpl({required this.repository});

  @override
  Future<Try<IaBellaDataEntity>> call(IaBellaStartSessionParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.startSession(params.condominiumId);
  }

  Failure? _validate(IaBellaStartSessionParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
