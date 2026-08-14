import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_rule.dart';
import 'package:lello/feature/space/reservation/domain/repository/reservation_rule_repository.dart';
import 'package:lello/feature/space/reservation/domain/use_case/get_reservation_rule/get_reservation_rule.dart';

class GetReservationRuleImpl extends GetReservationRule {
  final ReservationRuleRepository repository;

  GetReservationRuleImpl({required this.repository});

  @override
  Future<Try<ReservationRule>> call(GetReservationRuleParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return await repository.select(params.condominiumId, params.spaceId);
  }

  Failure? validate(GetReservationRuleParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    if (param.spaceId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
