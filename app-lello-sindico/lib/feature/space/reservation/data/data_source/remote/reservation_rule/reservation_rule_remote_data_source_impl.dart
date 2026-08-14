import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/data/data_source/remote/reservation_rule/reservation_rule_api.dart';
import 'package:lello/feature/space/reservation/data/data_source/remote/reservation_rule/reservation_rule_remote_data_source.dart';
import 'package:lello/feature/space/reservation/data/model/reservation_change_rules_model.dart';
import 'package:lello/feature/space/reservation/data/model/reservation_rule_model.dart';

class ReservationRuleRemoteDataSourceImpl
    extends ReservationRuleRemoteDataSource {
  final ReservationRuleApi api;
  ReservationRuleRemoteDataSourceImpl({required this.api});

  @override
  Future<ReservationRuleModel> select(
      String condominiumId, String spaceId) async {
    final response = await api.get(condominiumId, spaceId);
    return ApiMapper.map(
        response, (json) => ReservationRuleModel.fromJson(json));
  }

  //MOCKS PARA CHAMDA DE REGRA DE MUDANÇA

  @override
  Future<ReservationChangeRulesModel> getChangeRules(
      String condominiumId) async {
    final response = await api.getChangeRules(condominiumId);
    return ApiMapper.map(
        response, (json) => ReservationChangeRulesModel.fromJson(json));
  }

  @override
  Future<String> postChangeRules(
      String condominiumId, Map<String, dynamic> body) async {
    final response = await api.postChangeRules(condominiumId, body);
    if (response.isSuccessful == false) {
      print(response.error);
      throw response.error ?? "";
    } else {
      return "";
    }
  }
}
