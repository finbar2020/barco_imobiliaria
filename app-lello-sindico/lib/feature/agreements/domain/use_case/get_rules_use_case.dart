import 'package:essentials/essentials.dart';
import 'package:lello/feature/agreements/domain/entity/agreements_rules.dart';

abstract class GetRulesUseCase
    extends UseCase<AgreementsRules, GetRulesParams> {}

class GetRulesParams {
  final String condominiumId;
  GetRulesParams({
    required this.condominiumId,
  });
}
