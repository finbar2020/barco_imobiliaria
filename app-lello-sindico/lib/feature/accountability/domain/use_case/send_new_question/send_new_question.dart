import 'package:essentials/essentials.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt.dart';

abstract class SendAccountabilityQuestion
    extends UseCase<AccountabilityDoubt, SendAccountabilityQuestionParam> {}

class SendAccountabilityQuestionParam {
  final AccountabilityDoubt doubt;
  final String condominiumId;
  SendAccountabilityQuestionParam(
      {required this.doubt, required this.condominiumId});
}
