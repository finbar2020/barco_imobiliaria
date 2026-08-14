import 'package:essentials/essentials.dart';
import 'package:morar/feature/agreements/domain/entity/agreements_recommendatio_payment.dart';
import 'package:morar/feature/agreements/domain/repository/agreements_repository.dart';
import 'package:morar/feature/agreements/domain/use_case/get_recommendation/get_recommendation.dart';

class GetRecommendationUseCaseImpl extends GetRecommendationUseCase {
  final AgreementsRepository repository;

  GetRecommendationUseCaseImpl({required this.repository});
  @override
  Future<Try<List<AgreementRecommendationPayment>>> call(
      GetRecommendationParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);
    var response = await repository.getRecommendation(params.condoId);
    return response;
  }

  Failure? _validate(GetRecommendationParams? params) {
    if (params == null) return InvalidParamFailure();
    return null;
  }
}
