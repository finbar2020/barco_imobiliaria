import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/domain/entity/space.dart';

abstract class RegisterSpace extends UseCase<Space, RegisterSpaceParam> {}

class RegisterSpaceParam {
  final String condominiumId;
  final Space space;

  RegisterSpaceParam({required this.condominiumId, required this.space});
}
