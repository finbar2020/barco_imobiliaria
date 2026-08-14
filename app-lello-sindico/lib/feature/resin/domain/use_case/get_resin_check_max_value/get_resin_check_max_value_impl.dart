import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_check_max_value_param.dart';
import 'package:lello/feature/resin/domain/repository/resin_repository.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_check_max_value/get_resin_check_max_value.dart';

class GetResinCheckMaxValueUsecaseImpl extends GetResinCheckMaxValueUsecase {
  final ResinRepository repository;

  GetResinCheckMaxValueUsecaseImpl({required this.repository});

  @override
  Future<Try<ResinCheckMaxValueParam>> call(
      GetResinCheckMaxValueParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.checkMaxValue(
        params.condominiumId, params.type, params.value);
  }

  Failure? _validate(GetResinCheckMaxValueParams? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    if (param.type.isEmpty) return InvalidParamFailure();
    if (param.value <= 0) return InvalidParamFailure();
    return null;
  }
}
