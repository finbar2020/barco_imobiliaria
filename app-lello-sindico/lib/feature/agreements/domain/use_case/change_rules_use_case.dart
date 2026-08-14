import 'package:essentials/essentials.dart';
import 'package:lello/feature/agreements/domain/entity/agreements_rules.dart';

abstract class ChangeRulesUseCase
    extends UseCase<AgreementsRules, ChangeRulesParams> {}

class ChangeRulesParams {
  final String condominiumId;
  final AgreementsRules newRules;

  ChangeRulesParams({required this.condominiumId, required this.newRules});
}
