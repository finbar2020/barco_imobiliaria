import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request.dart';

abstract class ResendRequestUseCase
    extends UseCase<ComfortCompletedRequest, ResendRequestParam> {}

class ResendRequestParam {
  String condominiumId;
  String requestId;
  ResendRequestParam({
    required this.condominiumId,
    required this.requestId,
  });
}
