import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_purchase.dart';

abstract class FindRequestPurchaseUseCase
    extends UseCase<ComfortRequestPurchase, FindRequestPurchaseParam> {}

class FindRequestPurchaseParam {
  String condominiumId;
  String requestId;
  FindRequestPurchaseParam({
    required this.condominiumId,
    required this.requestId,
  });
}
