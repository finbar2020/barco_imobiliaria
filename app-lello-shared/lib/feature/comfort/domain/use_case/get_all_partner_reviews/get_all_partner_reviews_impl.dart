import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_review.dart';
import 'package:shared_features/feature/comfort/domain/repository/comfort_repository.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_all_partner_reviews/get_all_partner_reviews.dart';

class GetAllPartnerReviewsUseCaseImpl extends GetAllPartnerReviewsUseCase {
  final ComfortRepository repository;

  GetAllPartnerReviewsUseCaseImpl({required this.repository});

  @override
  Future<Try<List<ComfortPartnerReview>>> call(
      GetAllPartnerReviewsParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result = await repository.getAllPartnerReviews(
        params.condominiumId, params.partnerId);

    return result;
  }

  Failure? validate(GetAllPartnerReviewsParam params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    if (params.partnerId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
