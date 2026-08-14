import 'package:essentials/essentials.dart';
import 'package:morar/feature/change_ownership/domain/entity/can_change_entity.dart';

abstract class CanChangeUseCase
    extends UseCase<CanChangeEntity, CanChangeParams> {}

class CanChangeParams {
  final String condoId;

  CanChangeParams({required this.condoId});
}
