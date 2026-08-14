import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request.dart';

abstract class CancelRequestUseCase
    extends UseCase<ComfortCompletedRequest, CancelRequestParam> {}

class CancelRequestParam {
  String condominiumId;
  String requestId;
  CancelRequestParam({
    required this.condominiumId,
    required this.requestId,
  });
}
