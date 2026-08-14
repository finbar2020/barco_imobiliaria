import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request.dart';
import 'package:shared_features/feature/comfort/domain/repository/comfort_repository.dart';
import 'package:shared_features/feature/comfort/domain/use_case/cancel_request/cancel_request.dart';

class CancelRequestUseCaseImpl extends CancelRequestUseCase {
  final ComfortRepository repository;

  CancelRequestUseCaseImpl({required this.repository});

  @override
  Future<Try<ComfortCompletedRequest>> call(CancelRequestParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result =
        await repository.cancelRequest(params.condominiumId, params.requestId);

    return result;
  }

  Failure? validate(CancelRequestParam params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    if (params.requestId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
