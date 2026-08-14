import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_change_rules.dart';

abstract class GetReservationChangeRules
    extends UseCase<ReservationChangeRules, GetReservationChangeRulesParam> {}

class GetReservationChangeRulesParam {
  final String condominiumId;

  GetReservationChangeRulesParam({required this.condominiumId});
}
