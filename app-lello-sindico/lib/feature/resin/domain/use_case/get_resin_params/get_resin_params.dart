import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_params.dart';

abstract class GetResinParams
    extends UseCase<ResinParams, GetResinParamsParams> {}

class GetResinParamsParams {
  final String condominiumId;

  GetResinParamsParams({required this.condominiumId});
}
