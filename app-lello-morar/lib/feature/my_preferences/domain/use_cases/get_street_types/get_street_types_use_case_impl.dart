import 'package:essentials/functional/try.dart';

import 'package:morar/feature/my_preferences/domain/entities/street_type_entity.dart';

import '../../repositories/my_preferences_repository.dart';
import 'get_street_types_use_case.dart';

class GetStreetTypesUseCaseImpl implements GetStreetTypesUseCase {
  final MyPreferencesRepository _repo;

  GetStreetTypesUseCaseImpl(this._repo);

  @override
  Future<Try<List<StreetTypeEntity>>> call([void params]) =>
      _repo.getStreetTypesList();
}
