import 'package:essentials/essentials.dart';
import 'package:lello/feature/agreements/domain/entity/agreements_rules.dart';
import 'package:lello/feature/agreements/domain/repository/agreements_repository.dart';
import 'package:lello/feature/agreements/domain/use_case/get_rules_use_case.dart';

class GetRulesUseCaseImpl extends GetRulesUseCase {
  final AgreementsRepository repository;

  GetRulesUseCaseImpl({required this.repository});
  @override
  Future<Try<AgreementsRules>> call(GetRulesParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getRules(params.condominiumId);
  }

  Failure? _validate(GetRulesParams? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
