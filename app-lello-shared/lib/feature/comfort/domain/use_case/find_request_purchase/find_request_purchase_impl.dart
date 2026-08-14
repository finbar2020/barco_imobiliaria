import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_purchase.dart';
import 'package:shared_features/feature/comfort/domain/repository/comfort_repository.dart';
import 'package:shared_features/feature/comfort/domain/use_case/find_request_purchase/find_request_purchase.dart';

class FindRequestPurchaseUseCaseImpl extends FindRequestPurchaseUseCase {
  final ComfortRepository repository;

  FindRequestPurchaseUseCaseImpl({required this.repository});

  @override
  Future<Try<ComfortRequestPurchase>> call(
      FindRequestPurchaseParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result = await repository.findRequestPurchase(
        params.condominiumId, params.requestId);

    return result;
  }

  Failure? validate(FindRequestPurchaseParam params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    if (params.requestId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
