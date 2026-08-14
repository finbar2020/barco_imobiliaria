import 'package:essentials/essentials.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';
import 'package:lello/feature/resident/domain/repository/resident_repository.dart';
import 'package:lello/feature/unit/domain/use_case/list_unit_resident/list_unit_resident.dart';

class ListUnitResidentImpl extends ListUnitResident {
  final ResidentRepository repository;
  ListUnitResidentImpl({required this.repository});

  @override
  Future<Try<List<Resident>>> call(ListUnitResidentParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return await repository.listFromUnit(params.condominiumId, params.unitId);
  }

  Failure? validate(ListUnitResidentParam param) {
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    if (param.unitId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
