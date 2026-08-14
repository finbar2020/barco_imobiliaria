import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request.dart';
import 'package:shared_features/feature/comfort/domain/repository/comfort_repository.dart';
import 'package:shared_features/feature/comfort/domain/use_case/update_request/update_request.dart';

class UpdateRequestUseCaseImpl extends UpdateRequestUseCase {
  final ComfortRepository repository;

  UpdateRequestUseCaseImpl({required this.repository});

  @override
  Future<Try<ComfortCompletedRequest>> call(UpdateRequestParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result = await repository.updateRequest(
        params.condominiumId, params.requestId, params.request);

    return result;
  }

  Failure? validate(UpdateRequestParam params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    if (params.requestId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
