import 'package:essentials/essentials.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_all_info.dart';

abstract class GetAvailableUseCase
    extends UseCase<AgreementAllInfo, GetAvailableParams> {}

class GetAvailableParams {
  final String condoId;
  final String unitTitle;
  final bool onlyQuoteAndRule;

  GetAvailableParams({
    required this.condoId,
    required this.unitTitle,
    this.onlyQuoteAndRule = false,
  });
}
