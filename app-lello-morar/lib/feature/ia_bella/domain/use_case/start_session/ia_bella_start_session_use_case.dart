import 'package:essentials/essentials.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_data_entity.dart';

abstract class IaBellaStartSessionUseCase
    extends UseCase<IaBellaDataEntity, IaBellaStartSessionParam> {}

class IaBellaStartSessionParam {
  final String condominiumId;

  IaBellaStartSessionParam({required this.condominiumId});
}
