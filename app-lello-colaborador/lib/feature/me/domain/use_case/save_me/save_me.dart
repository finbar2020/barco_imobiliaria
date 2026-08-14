import 'package:colaborador/feature/me/domain/entity/me.dart';
import 'package:essentials/essentials.dart';
import 'package:shared_features/shared_features.dart';

abstract class SaveMe extends UseCase<Me?, SaveMeParam> {}

class SaveMeParam {
  final Me? me;
  final Me? originalMe;
  final CodeValidation? codeValidation;

  SaveMeParam({this.me, this.originalMe, this.codeValidation});
}
