import 'package:essentials/essentials.dart';
import 'package:morar/feature/change_ownership/domain/entity/ownership_entity.dart';

abstract class PostChangeUseCase
    extends UseCase<String, PostChangeParams> {}

class PostChangeParams {
  final String condoId;
  final OwnershipEntity entity;

  PostChangeParams({
    required this.condoId,
    required this.entity,
  });
}
