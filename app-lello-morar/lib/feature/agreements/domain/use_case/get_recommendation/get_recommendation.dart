import 'package:essentials/essentials.dart';
import 'package:morar/feature/agreements/domain/entity/agreements_recommendatio_payment.dart';

abstract class GetRecommendationUseCase extends UseCase<
    List<AgreementRecommendationPayment>, GetRecommendationParams> {}

class GetRecommendationParams {
  final String condoId;

  GetRecommendationParams({required this.condoId});
}
