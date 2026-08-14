import 'package:essentials/functional/failure.dart';
import 'package:essentials/functional/try.dart';
import 'package:morar/feature/my_preferences/domain/repositories/my_preferences_repository.dart';
import 'package:morar/feature/my_preferences/domain/use_cases/update_unit_personal_data/update_unit_personal_data_use_case.dart';

import '../../entities/access_data_entity.dart';

class UpdateUnitPersonalDataUseCaseImpl
    implements UpdateUnitPersonalDataUseCase {
  final MyPreferencesRepository _repository;

  UpdateUnitPersonalDataUseCaseImpl(this._repository);

  @override
  Future<Try<AccessData>> call(AccessData unitPersonalData) async {
    final error = validate(unitPersonalData);

    if (error != null) return Rejection(error);
    final result = await _repository.updateUnitPersonalData(unitPersonalData);

    return result;
  }

  Failure? validate(AccessData unitPersonalData) {
    if (unitPersonalData.personalData?.cpf.isEmpty == true)
      return InvalidParamFailure();
    return null;
  }
}
