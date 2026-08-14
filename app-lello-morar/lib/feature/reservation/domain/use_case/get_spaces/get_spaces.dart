import 'package:essentials/essentials.dart';
import 'package:morar/feature/reservation/domain/entity/space.dart';

abstract class GetSpace extends UseCase<List<Space>, GetSpaceParam> {}

class GetSpaceParam {
  final String condominiumId;

  GetSpaceParam({required this.condominiumId});
}
