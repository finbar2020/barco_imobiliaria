import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/domain/entity/space.dart';

abstract class ListSpace extends UseCase<List<Space>, ListSpaceParam> {}

class ListSpaceParam {
  final String condominiumId;
  final DataOrigin origin;
  ListSpaceParam({required this.condominiumId, required this.origin});
}
