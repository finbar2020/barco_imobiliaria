import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/domain/entity/space.dart';

abstract class UpdateSpace extends UseCase<Space, UpdateSpaceParam> {}

class UpdateSpaceParam {
  final String condominiumId;
  final Space space;

  UpdateSpaceParam({required this.condominiumId, required this.space});
}
