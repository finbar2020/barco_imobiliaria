import 'package:essentials/essentials.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt.dart';
import 'package:lello/feature/accountability/domain/repository/accountability_repository.dart';

class SendAccountabilityQuestionUsecase
    extends UseCase<AccountabilityDoubt, SendAccountabilityQuestionParam> {
  final AccountabilityRepository repository;

  SendAccountabilityQuestionUsecase({required this.repository});

  @override
  Future<Try<AccountabilityDoubt>> call(
      SendAccountabilityQuestionParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.sendDoubt(params.condominiumId, params.doubt);
  }

  Failure? _validate(SendAccountabilityQuestionParam? param) {
    if (param == null) return InvalidParamFailure();
    return null;
  }
}

class SendAccountabilityQuestionParam {
  final AccountabilityDoubt doubt;
  final String condominiumId;
  SendAccountabilityQuestionParam({
    required this.doubt,
    required this.condominiumId,
  });
}
