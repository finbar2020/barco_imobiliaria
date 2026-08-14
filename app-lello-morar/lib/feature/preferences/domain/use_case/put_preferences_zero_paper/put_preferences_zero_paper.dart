import 'package:essentials/essentials.dart';
import 'package:morar/feature/preferences/domain/entity/preferences_entity.dart';

abstract class PutZeroPaperUseCase extends UseCase<String, PutZeroPaperParam> {}

class PutZeroPaperParam {
  final PreferencesEntity entity;
  PutZeroPaperParam({required this.entity});
}
