import 'package:essentials/essentials.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';

abstract class ListUnitResident
    extends UseCase<List<Resident>, ListUnitResidentParam> {}

class ListUnitResidentParam {
  final String condominiumId;
  final String unitId;

  ListUnitResidentParam({required this.condominiumId, required this.unitId});
}
