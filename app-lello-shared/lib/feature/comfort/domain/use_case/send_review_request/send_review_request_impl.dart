import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_review_request.dart';
import 'package:shared_features/feature/comfort/domain/repository/comfort_repository.dart';
import 'package:shared_features/feature/comfort/domain/use_case/send_review_request/send_review_request.dart';

class SendReviewRequestUseCaseImpl extends SendReviewRequestUseCase {
  final ComfortRepository repository;

  SendReviewRequestUseCaseImpl({required this.repository});

  @override
  Future<Try<ComfortReviewRequest>> call(SendReviewRequestParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result =
        await repository.sendReviewRequest(params.condominiumId, params.review);

    return result;
  }

  Failure? validate(SendReviewRequestParam params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    if (params.review.requestId.isEmpty) return InvalidParamFailure();
    if (params.review.rating < 0 || params.review.rating > 5)
      return InvalidParamFailure();
    return null;
  }
}
