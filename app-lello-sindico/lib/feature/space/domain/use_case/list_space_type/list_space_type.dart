import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/domain/entity/space_type.dart';

abstract class ListSpaceType
    extends UseCase<List<SpaceType>, ListSpaceTypeParam> {}

class ListSpaceTypeParam {
  final String condominiumId;
  ListSpaceTypeParam({required this.condominiumId});
}
