// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:morar/feature/easy_fix/domain/entity/easy_fix_unit_entity.dart';

import 'package:essentials/essentials.dart';

import '../repository/easy_fix_repository.dart';

class UpdateAddressUsecase extends UseCase<void, UpdateAddressParams> {
  final EasyFixRepository _repository;
  UpdateAddressUsecase({
    required EasyFixRepository repository,
  }) : _repository = repository;

  @override
  Future<Try<void>> call(UpdateAddressParams params) async {
    return await _repository.updateAddress(
      condominiumId: params.condominiumId,
      unit: params.unit,
    );
  }
}

class UpdateAddressParams {
  final String condominiumId;
  final EasyFixUnit unit;
  UpdateAddressParams({
    required this.condominiumId,
    required this.unit,
  });
}
