import 'package:lello/feature/agreements/data/model/agreements_all_info_model.dart';
import 'package:lello/feature/agreements/data/model/agreements_rules_model.dart';

abstract class AgreementsLocalDataSource {
  Future<AgreementsAllInfoModel?> selectAllInfo(String condominiumId);
  Future<AgreementsRulesModel?> saveRules(
      AgreementsRulesModel rules, String condominiumId);
  Future<AgreementsAllInfoModel?> saveAllInfo(
      AgreementsAllInfoModel? model, String condominiumId);
}
