import 'package:essentials/essentials.dart';
import 'package:lello/feature/agreements/domain/entity/agreements_rules.dart';
import 'package:lello/feature/agreements/domain/repository/agreements_repository.dart';
import 'package:lello/feature/agreements/domain/use_case/change_rules_use_case.dart';

class ChangeRulesUseCaseImpl extends ChangeRulesUseCase {
  final AgreementsRepository repository;

  ChangeRulesUseCaseImpl({required this.repository});
  @override
  Future<Try<AgreementsRules>> call(ChangeRulesParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.changeRules(params.condominiumId, params.newRules);
  }

  Failure? _validate(ChangeRulesParams? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condominiumId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
