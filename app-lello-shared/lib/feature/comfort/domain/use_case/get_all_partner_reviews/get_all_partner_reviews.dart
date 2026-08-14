import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_review.dart';

abstract class GetAllPartnerReviewsUseCase
    extends UseCase<List<ComfortPartnerReview>, GetAllPartnerReviewsParam> {}

class GetAllPartnerReviewsParam {
  String condominiumId;
  String partnerId;
  GetAllPartnerReviewsParam({
    required this.condominiumId,
    required this.partnerId,
  });
}
