import 'package:essentials/essentials.dart';
import 'package:morar/feature/preferences/domain/entity/preferences_zero_paper_entity.dart';

abstract class GetZeroPaperUseCase
    extends UseCase<PreferencesZeroPaperEntity, GetZeroPaperParam> {}

class GetZeroPaperParam {
  final String unityId;
  GetZeroPaperParam({required this.unityId});
}
