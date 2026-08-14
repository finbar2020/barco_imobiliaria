import 'package:colaborador/feature/authentication_tablet/domain/entity/condominium_code_info.dart';
import 'package:essentials/essentials.dart';

abstract class GetInfoByCondoCodeUseCase
    extends UseCase<CondominiumCodeInfo, GetInfoByCondoCodeParams> {}

class GetInfoByCondoCodeParams {
  final String? condoCode;
  final DataOrigin origin;

  GetInfoByCondoCodeParams({this.condoCode, required this.origin});
}
