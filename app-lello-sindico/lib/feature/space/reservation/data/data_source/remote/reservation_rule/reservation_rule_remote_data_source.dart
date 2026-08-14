import 'package:lello/feature/space/reservation/data/model/reservation_change_rules_model.dart';
import 'package:lello/feature/space/reservation/data/model/reservation_rule_model.dart';

abstract class ReservationRuleRemoteDataSource {
  Future<ReservationRuleModel> select(String condominiumId, String spaceId);

//CHAMADAS MOCKADAS PARA TESTAR REGRAS DE MUDANÇA
  Future<ReservationChangeRulesModel> getChangeRules(String condominiumId);
  Future<String> postChangeRules(
      String condominiumId, Map<String, dynamic> body);
}
