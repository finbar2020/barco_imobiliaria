import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_simple.dart';
import 'package:lello/feature/condominium/domain/repository/condominium_simple_repository.dart';
import 'package:lello/feature/condominium/domain/use_case/get_simple_condominium/get_simple_condominium.dart';

class GetSimpleCondominiumUsecaseImpl extends GetSimpleCondominiumUsecase {
  final CondominiumSimpleRepository repository;

  GetSimpleCondominiumUsecaseImpl({required this.repository});

  @override
  Future<Try<CondominiumSimple?>> call(
      GetSimpleCondominiumParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getSimpleCondominium(params: params);
  }

  Failure? _validate(GetSimpleCondominiumParams? params) {
    if (params?.id == null) return InvalidParamFailure();

    return null;
  }
}
