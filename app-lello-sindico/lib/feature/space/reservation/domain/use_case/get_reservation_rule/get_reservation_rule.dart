import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_rule.dart';

abstract class GetReservationRule
    extends UseCase<ReservationRule, GetReservationRuleParam> {}

class GetReservationRuleParam {
  final String condominiumId;
  final String spaceId;

  GetReservationRuleParam({required this.condominiumId, required this.spaceId});
}
