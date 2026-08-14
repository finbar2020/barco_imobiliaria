import 'package:essentials/essentials.dart';
import 'package:morar/feature/easy_fix/domain/entity/city_entity.dart';

import '../repository/easy_fix_repository.dart';

class GetCitiesUsecase extends UseCase<List<City>, GetCitiesParams> {
  final EasyFixRepository _repository;
  GetCitiesUsecase({
    required EasyFixRepository repository,
  }) : _repository = repository;

  @override
  Future<Try<List<City>>> call(GetCitiesParams params) async {
    return await _repository.getCities(
      condominiumId: params.condominiumId,
      uf: params.uf,
    );
  }
}

class GetCitiesParams {
  final String condominiumId;
  final String uf;
  GetCitiesParams({
    required this.uf,
    required this.condominiumId,
  });
}
