import 'package:essentials/essentials.dart';

import '../../repository/accountability_repository.dart';

class ApproveRecommendationUsecase
    extends UseCase<void, ApproveRecommendationParams> {
  final AccountabilityRepository repository;

  ApproveRecommendationUsecase({required this.repository});

  @override
  Future<Try<void>> call(ApproveRecommendationParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return repository.sendRecommendation(params.condominiumId, params.period);
  }

  Failure? _validate(ApproveRecommendationParams? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condominiumId.isEmpty) return InvalidParamFailure();

    return null;
  }
}

class ApproveRecommendationParams {
  final DateTime period;
  final String condominiumId;
  ApproveRecommendationParams({
    required this.period,
    required this.condominiumId,
  });
}
