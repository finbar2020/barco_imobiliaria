import 'package:essentials/functional/failure.dart';
import 'package:essentials/functional/try.dart';
import 'package:morar/feature/my_preferences/domain/repositories/my_preferences_repository.dart';

import '../../entities/access_data_entity.dart';
import 'get_unit_personal_data_use_case.dart';

class GetUnitPersonalDataUseCaseImpl extends GetUnitPersonalDataUseCase {
  final MyPreferencesRepository _repository;

  GetUnitPersonalDataUseCaseImpl(this._repository);

  @override
  Future<Try<AccessData>> call(int unitId) async {
    final error = validate(unitId);

    if (error != null) return Rejection(error);
    final result = await _repository.getUnitPersonalData(unitId);

    return result;
  }

  Failure? validate(int unitId) {
    if (unitId.isNegative) return InvalidParamFailure();
    return null;
  }
}
