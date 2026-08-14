import 'package:essentials/essentials.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt_situation.dart';
import 'package:lello/feature/accountability/domain/repository/accountability_repository.dart';

class ListAccountabilityDoubtUsecase
    extends UseCase<List<AccountabilityDoubt>, ListAccountabilityDoubtParam> {
  final AccountabilityRepository repository;

  ListAccountabilityDoubtUsecase({required this.repository});

  @override
  Future<Try<List<AccountabilityDoubt>>> call(
      ListAccountabilityDoubtParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.listDoubt(
        params.condominiumId, params.questionSituation);
  }

  Failure? _validate(ListAccountabilityDoubtParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}

class ListAccountabilityDoubtParam {
  final String condominiumId;
  final DoubtSituation? questionSituation;

  ListAccountabilityDoubtParam({
    required this.condominiumId,
    required this.questionSituation,
  });
}
