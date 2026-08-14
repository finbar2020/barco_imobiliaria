import 'package:morar/feature/easy_fix/domain/entity/easy_fix_unit_entity.dart';

import 'package:essentials/essentials.dart';

import '../repository/easy_fix_repository.dart';

class GetEasyFixUnitUsecase extends UseCase<EasyFixUnit, GetEasyFixUnitParam> {
  final EasyFixRepository _repository;
  GetEasyFixUnitUsecase({
    required EasyFixRepository repository,
  }) : _repository = repository;

  @override
  Future<Try<EasyFixUnit>> call(GetEasyFixUnitParam params) async {
    return await _repository.getEasyFixUnit(
      condominiumId: params.condominiumId,
    );
  }
}

class GetEasyFixUnitParam {
  final String condominiumId;
  GetEasyFixUnitParam({
    required this.condominiumId,
  });
}
