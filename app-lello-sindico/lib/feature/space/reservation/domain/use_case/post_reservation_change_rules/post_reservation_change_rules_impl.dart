import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/repository/reservation_rule_repository.dart';
import 'package:lello/feature/space/reservation/domain/use_case/post_reservation_change_rules/post_reservation_change_rules.dart';

class PostReservationChangeRulesImpl extends PostReservationChangeRules {
  final ReservationRuleRepository repository;
  PostReservationChangeRulesImpl({required this.repository});

  @override
  Future<Try<String>> call(PostReservationChangeRulesParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.postChangeRules(params.condominiumId, params.body);
  }

  Failure? _validate(PostReservationChangeRulesParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
