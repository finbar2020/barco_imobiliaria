import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_params.dart';
import 'package:lello/feature/resin/domain/repository/resin_repository.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_params/get_resin_params.dart';

class GetResinParamsImpl extends GetResinParams {
  final ResinRepository repository;

  GetResinParamsImpl({required this.repository});

  @override
  Future<Try<ResinParams>> call(GetResinParamsParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getResinParams(params.condominiumId);
  }

  Failure? _validate(GetResinParamsParams? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
