import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_person.dart';

abstract class GetResinPeople
    extends UseCase<List<ResinPerson>, GetResinPeopleParams> {}

class GetResinPeopleParams {
  final String condominiumId;
  final DataOrigin origin;

  GetResinPeopleParams({
    required this.condominiumId,
    required this.origin,
  });
}
