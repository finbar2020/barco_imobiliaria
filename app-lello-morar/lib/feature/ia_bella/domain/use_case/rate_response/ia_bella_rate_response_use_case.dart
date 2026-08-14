import 'package:essentials/essentials.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_rate_response_model.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_rate_response_entity.dart';

abstract class IaBellaRateResponseUseCase
    extends UseCase<IaBellaRateResponseEntity, IaBellaRateResponseParam> {}

class IaBellaRateResponseParam {
  final String condominiumId;
  IaBellaRateResponseModel userRate;

  IaBellaRateResponseParam(
      {required this.condominiumId, required this.userRate});
}
