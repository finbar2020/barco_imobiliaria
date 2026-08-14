import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request.dart';

abstract class UpdateRequestUseCase
    extends UseCase<ComfortCompletedRequest, UpdateRequestParam> {}

class UpdateRequestParam {
  String condominiumId;
  String requestId;
  ComfortCompletedRequest request;
  UpdateRequestParam({
    required this.condominiumId,
    required this.requestId,
    required this.request,
  });
}
