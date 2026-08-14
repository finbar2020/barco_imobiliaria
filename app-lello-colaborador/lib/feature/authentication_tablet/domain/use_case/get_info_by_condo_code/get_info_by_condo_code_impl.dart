import 'package:colaborador/feature/authentication_tablet/domain/entity/condominium_code_info.dart';
import 'package:colaborador/feature/authentication_tablet/domain/repository/authentication_tablet_repository.dart';
import 'package:colaborador/feature/authentication_tablet/domain/use_case/get_info_by_condo_code/get_info_by_condo_code.dart';
import 'package:essentials/essentials.dart';

class GetInfoByCondoCodeUseCaseImpl extends GetInfoByCondoCodeUseCase {
  final AuthenticationTabletRepository repository;
  GetInfoByCondoCodeUseCaseImpl({required this.repository});

  @override
  Future<Try<CondominiumCodeInfo>> call(GetInfoByCondoCodeParams params) async {
    switch (params.origin) {
      case DataOrigin.local:
        return await repository.getInfoByCondoCodeFromCache();
      case DataOrigin.remote:
        return await repository.getInfoByCondoCode(params.condoCode!);
    }
  }

  Failure? validate(GetInfoByCondoCodeParams? params) {
    if (params == null) return InvalidParamFailure();
    if (params.origin == DataOrigin.remote && params.condoCode == null) {
      return InvalidParamFailure();
    }
    return null;
  }
}
