import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request.dart';
import 'package:shared_features/feature/comfort/domain/repository/comfort_repository.dart';
import 'package:shared_features/feature/comfort/domain/use_case/resend_request/resend_request.dart';

class ResendRequestUseCaseImpl extends ResendRequestUseCase {
  final ComfortRepository repository;

  ResendRequestUseCaseImpl({required this.repository});

  @override
  Future<Try<ComfortCompletedRequest>> call(ResendRequestParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result =
        await repository.resendRequest(params.condominiumId, params.requestId);

    return result;
  }

  Failure? validate(ResendRequestParam params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    if (params.requestId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
