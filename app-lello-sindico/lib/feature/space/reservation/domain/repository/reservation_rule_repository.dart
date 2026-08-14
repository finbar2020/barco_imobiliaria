import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_change_rules.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_rule.dart';

abstract class ReservationRuleRepository {
  Future<Try<ReservationRule>> select(String condominiumId, String spaceId);
  Future<Try<ReservationChangeRules>> getChangeRules(String condominiumId);
  Future<Try<String>> postChangeRules(
      String condominiumId, Map<String, dynamic> body);
}
