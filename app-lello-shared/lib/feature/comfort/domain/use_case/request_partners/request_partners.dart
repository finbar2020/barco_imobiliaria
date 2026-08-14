import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/request_partners_entity.dart';

abstract class RequestPartnersUseCase
    extends UseCase<bool, RequestPartnersUseCaseParam> {}

class RequestPartnersUseCaseParam {
  String condominiumId;
  RequestPartnersEntity request;

  RequestPartnersUseCaseParam({
    required this.condominiumId,
    required this.request,
  });
}
