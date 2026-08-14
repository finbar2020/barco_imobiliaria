import 'package:essentials/essentials.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_question_type_solicitation.dart';
import 'package:lello/feature/accountability/domain/repository/accountability_repository.dart';

class GetAccountabilityQuestionUsecase extends UseCase<
    List<AccountabilityQuestionType>, GetAccountabilityQuestionParam> {
  final AccountabilityRepository repository;

  GetAccountabilityQuestionUsecase({required this.repository});

  @override
  Future<Try<List<AccountabilityQuestionType>>> call(
      GetAccountabilityQuestionParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.listType(params.condominiumId);
  }

  Failure? _validate(GetAccountabilityQuestionParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}

class GetAccountabilityQuestionParam {
  final String condominiumId;

  GetAccountabilityQuestionParam({required this.condominiumId});
}
