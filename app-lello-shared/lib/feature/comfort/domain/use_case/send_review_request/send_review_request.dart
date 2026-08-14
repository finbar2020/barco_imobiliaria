import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_review_request.dart';

abstract class SendReviewRequestUseCase
    extends UseCase<ComfortReviewRequest, SendReviewRequestParam> {}

class SendReviewRequestParam {
  String condominiumId;
  ComfortReviewRequest review;

  SendReviewRequestParam({
    required this.condominiumId,
    required this.review,
  });
}
