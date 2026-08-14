import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_person.dart';
import 'package:lello/feature/resin/domain/repository/resin_repository.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_people/get_resin_people.dart';

class GetResinPeopleImpl extends GetResinPeople {
  final ResinRepository repository;

  GetResinPeopleImpl({required this.repository});

  @override
  Future<Try<List<ResinPerson>>> call(GetResinPeopleParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return params.origin == DataOrigin.local
        ? await repository.getResinPeopleFromCache(params.condominiumId)
        : await repository.getResinPeople(params.condominiumId);
  }

  Failure? _validate(GetResinPeopleParams? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
