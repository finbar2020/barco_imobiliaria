import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_change_rules.dart';
import 'package:lello/feature/space/reservation/domain/repository/reservation_rule_repository.dart';
import 'package:lello/feature/space/reservation/domain/use_case/get_reservation_change_rules/get_reservation_change_rules.dart';

class GetReservationChangeRulesImpl extends GetReservationChangeRules {
  final ReservationRuleRepository repository;
  GetReservationChangeRulesImpl({required this.repository});

  @override
  Future<Try<ReservationChangeRules>> call(
      GetReservationChangeRulesParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getChangeRules(params.condominiumId);
  }

  Failure? _validate(GetReservationChangeRulesParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
